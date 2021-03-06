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

Given /^the morbidity event has the following contacts:$/ do |contacts|
  contacts.hashes.each do |contact|
    hash = {
      "interested_party_attributes" => {
        "person_entity_attributes" => {
          "person_attributes" => contact
        }
      }
    }
    @event.contact_child_events << ContactEvent.create!(hash)
  end
  @event.save!
end

Given /^the morbidity event has the following deleted contacts:$/ do |contacts|
  contacts.hashes.each do |contact|
    hash = {
      "interested_party_attributes" => {
        "person_entity_attributes" => {
          "person_attributes" => contact
        }
      }
    }    
    @event.contact_child_events << ContactEvent.create(hash)
    @event.contact_child_events.last.transactional_soft_delete    
  end
  @event.save!
  puts @event.contact_child_events.active.size
end

When /^I print the morbidity event$/ do
  visit cmr_path(@event, :format => :print)
end

Then /^I should see "([^\"]*)" under contact reports$/ do |value|
  response.should have_xpath("//div[@id='contact-reports']//span[contains(text(),'#{value}')]")
end

Then /^I should not see "([^\"]*)" under contact reports$/ do |value|
  response.should_not have_xpath("//div[@id='contact-reports']//span[contains(text(),'#{value}')]")
end

