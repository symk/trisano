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

require File.dirname(__FILE__) + '/spec_helper'
require File.dirname(__FILE__) + '/fb_fu_contact_patient_address_base'
require 'date'
 
describe 'form builder patient-level address follow-ups for contact events' do

#  $dont_kill_browser = true

  $fields = [
    {:name => 'Contact county', :label => "//div[@id='demographic_tab']//div[@id='person_form']//select[contains(@id, '_county_id')]", :entry_type => 'select', :code => 'Code: Utah (county)', :fu_value => 'Utah', :no_fu_value => 'Davis'},
    {:name => 'Contact zip code', :label => "//div[@id='demographic_tab']//div[@id='person_form']//input[contains(@id, '_postal_code')]", :entry_type => 'type', :fu_value => '89011', :no_fu_value => '80001'}
  ]

  it_should_behave_like "form builder patient-level address follow-ups for fields on contact events"
end
