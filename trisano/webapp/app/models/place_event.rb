# Copyright (C) 2007, 2008, The Collaborative Software Foundation
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

class PlaceEvent < Event

  class << self
    def initialize_from_morbidity_event(morbidity_event)
      place_events = []
      morbidity_event.place_exposures.select(&:new_record?).each do |place_exposure|

        primary = Participation.new
        primary.primary_entity = place_exposure.secondary_entity
        primary.role_id = Event.participation_code('Place Exposure')

        contact = Participation.new
        contact.secondary_entity = morbidity_event.active_patient.active_primary_entity
        contact.role_id = Event.participation_code('Contact')
        
        jurisdiction = Participation.new
        jurisdiction.secondary_entity = morbidity_event.active_jurisdiction.active_secondary_entity
        jurisdiction.role_id = Event.participation_code('Jurisdiction') 

        unless morbidity_event.disease.nil?
          disease_event = DiseaseEvent.new
          disease_event.disease = morbidity_event.disease.disease
        end

        place_event = PlaceEvent.new
        place_event.participations << primary
        place_event.participations << contact
        place_event.participations << jurisdiction
        place_event.disease_events << disease_event unless morbidity_event.disease.nil?
        place_events << place_event
      end
      place_events
    end
  end

end