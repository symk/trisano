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

require File.dirname(__FILE__) + '/spec_helper'

# $dont_kill_browser = true

describe 'Form Builder Admin Delete Group Functionality' do
  
  before(:all) do
    @form_name = get_unique_name(2) + " gd-uat"
    @cmr_last_name = get_unique_name(1) + " gd-uat"
    @group_name = get_unique_name(2)  + " grp gd-uat"
    @question_text = get_unique_name(2)  + " question gd-uat"
  end
  
  after(:all) do
    @form_name = nil
    @cmr_last_name = nil
    @group_name = nil
    @question_text = nil
    end
  
  it 'should add a group to the form' do
    create_new_form_and_go_to_builder(@browser, @form_name, "African Tick Bite Fever", "All Jurisdictions")
    
    add_question_to_view(@browser, "Default View", {:question_text => @question_text, :data_type => "Single line text"})
    add_question_to_library(@browser, @question_text, @group_name)
    delete_question(@browser, @question_text).should be_true    
    add_all_questions_from_group_to_view(@browser, "Default View", @group_name)
    publish_form(@browser)
    create_basic_investigatable_cmr(@browser, @cmr_last_name, "African Tick Bite Fever", "Bear River Health Department")
    edit_cmr(@browser)
    
    @browser.is_text_present(@question_text).should be_true
    
    click_nav_forms(@browser)
    click_build_form(@browser, @form_name)
    
    delete_group(@browser, @group_name).should be_true
    
    publish_form(@browser)
    click_nav_cmrs(@browser)
    click_resource_edit(@browser, "cmrs", @cmr_last_name)
   
    @browser.is_text_present(@question_text).should be_false
    
  end
    
end