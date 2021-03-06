# Copyright (C) 2007, 2008, 2009 The Collaborative Software Foundation
#
# This file is part of TriSano.
#
# TriSano is free software: you can redistribute it and/or modify it under the 
# terms of the GNU Affero General Public License as published by the 
# Free Software Foundation, either version 3 of the License, 
# or (at your option) any later version.
#
# TriSano is distributed in the hope that it will be useful, but 
# WITHOUT ANY WARRANTY; without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License 
# along with TriSano. If not, see http://www.gnu.org/licenses/agpl-3.0.txt.

class ContactEvent < HumanEvent
  include Workflow

  supports :tasks
  supports :attachments
  
  before_create do |contact|
    contact.add_note("Contact event created.")
  end

  workflow do
    # on_entry evaluated at wrong time, so note is attached to meta for :new
    state :new, :meta => {:note_text => '"Event created for jurisdiction #{self.primary_jurisdiction.name}."'} do
      assign_to_lhd
    end        
    state :assigned_to_lhd, :meta => {:description => 'Assigned to Local Health Dept.'} do
      assign_to_lhd
      accept_by_lhd :accept
      reject_by_lhd :reject
    end
    state :accepted_by_lhd, :meta => {:description => 'Accepted by Local Health Dept.'} do
      assign_to_lhd
      assign_to_investigator
      investigate
    end 
    state :rejected_by_lhd, :meta => {:description => "Rejected by Local Health Dept."} do
      on_entry do |prior_state, triggering_event, *event_args|
        self.route_to_jurisdiction(Place.jurisdiction_by_name("Unassigned"))
      end
      assign_to_lhd
    end
    state :assigned_to_investigator do
      assign_to_lhd
      investigate :accept
      reject_by_investigator :reject
      assign_to_investigator
      # need a way to reset state if an event queue goes away.
      event :reset, :transitions_to => :accepted_by_lhd do
        halt! "Investigator already assigned" unless investigator.nil?
      end
    end
    state :under_investigation, :meta => {:description => 'Assigned to Investigator'} do
      on_entry do |prior_state, triggering_event, *event_args|
        self.investigator_id = User.current_user.id
        self.investigation_started_date = Date.today
      end
      assign_to_lhd
      complete_investigation :complete
      complete_and_close_investigation :complete_and_close
      assign_to_investigator
    end
    state :rejected_by_investigator do
      on_entry do |prior_state, triggering_event, *event_args| 
        self.investigator_id = nil
        self.investigation_started_date = nil
      end
      assign_to_lhd
      assign_to_investigator
      investigate
    end
    state :investigation_complete do
      on_entry do |prior_state, triggering_event, *event_args|
        self.investigation_completed_LHD_date = Date.today
      end
      assign_to_lhd
      assign_to_investigator
      close_contact :approve
      reopen_by_manager :reopen
    end
    state :reopened_by_manager do
      on_entry do |prior_event, transition, *args|
        self.investigation_completed_LHD_date = nil
      end
      assign_to_lhd
      assign_to_investigator
      complete_investigation :close
      complete_and_close_investigation :complete_and_close
    end
    state :closed do
      assign_to_lhd
    end        
  end

  class << self
    def core_views
      [
        ["Demographics", "Demographics"], 
        ["Clinical", "Clinical"], 
        ["Laboratory", "Laboratory"], 
        ["Epidemiological", "Epidemiological"]
      ]
    end
  end

  # If you're wondering why calling #destroy on a contact event isn't deleting the record, this is why.
  # Override destroy to soft-delete record instead.  This makes it easier to work with :autosave.
  def destroy
    self.soft_delete
  end

  def promote_to_morbidity_event
    raise "Cannot promote an unsaved contact to a morbidity event" if self.new_record?
    self['type'] = MorbidityEvent.to_s
    # Pull morb forms
    if self.disease_event && self.disease_event.disease
      jurisdiction = self.jurisdiction ? self.jurisdiction.secondary_entity_id : nil
      self.add_forms(Form.get_published_investigation_forms(self.disease_event.disease_id, jurisdiction, 'morbidity_event'))
    end
    self.add_note("Event changed from contact event to morbidity event")

    if self.save
      self.freeze
      # Return a fresh copy from the db
      MorbidityEvent.find(self.id)
    else
      false
    end
  end

  def copy_event(new_event, event_components)
    super
    # When we get a story asking for it, this is where we will copy over the (now poorly named) participations_contacts info to a new event.
    # That is, disposition etc.
  end
  
end
