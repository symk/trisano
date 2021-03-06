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

def log_in_as(user)
  visit home_path unless current_url
  select user, :from => "user_id"
  submit_form "switch_user"
end

def create_basic_event(event_type, last_name, disease=nil, jurisdiction=nil)
  returning Kernel.const_get(event_type.capitalize + "Event").new do |event|
    event.attributes = { :interested_party_attributes => { :person_entity_attributes => { :person_attributes => { :last_name => last_name } } } }
    event.build_disease_event(:disease_id => Disease.find_by_disease_name(disease).id) if disease
    event.build_jurisdiction(:secondary_entity_id => Place.all_by_name_and_types(jurisdiction || "Unassigned", 'J', true).first.entity_id)
    event.create_form_references  # If there are any, we might want em
    event.save!
    event
  end
end

def add_child_to_event(event, child_last_name)
  returning event.contact_child_events.build do |child|
    child.attributes = { :interested_party_attributes => { :person_entity_attributes => { :person_attributes => { :last_name => child_last_name } } } }
    event.save!
    child.create_form_references
    child.save
  end
end

def jurisdiction_id_by_name(name)
  Place.all_by_name_and_types(name || "Unassigned", 'J', true).first.entity_id
end

def create_place(place_name, place_type)
  type = Code.find_by_code_name_and_the_code("placetype", place_type)
  place_entity = PlaceEntity.new
  place_entity.build_place(:name => place_name)
  place_entity.place.place_types << type
  place_entity.save
end

def place_child_events_attributes(values)
  { "5"=>{
      "interested_place_attributes"=>{
        "place_entity_attributes"=>{
          "place_attributes"=>{
            "name"=>"#{values[:name]}"
          }
        }
      },
      "participations_place_attributes"=>{
        "date_of_exposure"=>""
      }
    }
  }
end

def lab_attributes(values)
  { "3"=>{
      "place_entity_attributes"=>{
        "place_attributes"=>{
          "name"=>"#{values[:name] if values[:name]}"
        }
      },
      "lab_results_attributes"=>{
        "0"=>{
          "test_type"=>"#{values[:test_type] if values[:test_type]}", "test_detail"=>"#{values[:test_detail] if values[:test_detail]}", "lab_result_text"=>"#{values[:lab_result_text] if values[:lab_result_text]}", "reference_range"=>"", "interpretation_id"=>"",
          "specimen_source_id"=>"", "collection_date"=>"", "lab_test_date"=>"", "specimen_sent_to_uphl_yn_id"=>""
        }
      }
    }
  }
end
