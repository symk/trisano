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
 
describe 'form builder core-tab questions for places' do
  
   # $dont_kill_browser = true
  
  before(:all) do
    @form_name = get_unique_name(2)  << " pct-uat"
    @cmr_last_name = get_unique_name(1)  << " pct-uat"
    @place_name = get_unique_name(1)  << " pct-uat"
    
    @place_question_text = get_unique_name(2)  << " pct-uat"
    @place_answer = get_unique_name(2)  << " pct-uat"
  end
  
  after(:all) do
    @form_name = nil
    @cmr_last_name = nil
    @place_name = nil
    
    @place_question_text = nil
    @place_answer = nil
  end
  
  it 'should create a new form with user-defined, core-tab questions' do
    create_new_form_and_go_to_builder(@browser, @form_name, "Hansen disease (Leprosy)", "All Jurisdictions", "Place event").should be_true
    add_core_tab_configuration(@browser, PLACE).should be_true
    add_question_to_view(@browser, PLACE, {:question_text =>@place_question_text, :data_type => "Single line text", :short_name => get_random_word}).should be_true
  end
    
  it "should publish the form and create an investigatable CMR with a place" do
    publish_form(@browser).should be_true
    create_basic_investigatable_cmr(@browser, @cmr_last_name, "Hansen disease (Leprosy)", "Bear River Health Department").should be_true
    edit_cmr(@browser).should be_true
    add_place(@browser, {:name => @place_name})
    save_cmr(@browser).should be_true
    click_link_by_order(@browser, "edit-place-event", 1)
    @browser.wait_for_page_to_load($load_time)
  end
  
  it 'should place user-defined questions on the correct tabs' do
    assert_tab_contains_question(@browser, PLACE, @place_question_text).should be_true
  end
    
  it 'should allow answers to be saved' do
    click_core_tab(@browser, PLACE)
    answer_investigator_question(@browser, @place_question_text, @place_answer).should be_true
    save_place_event(@browser).should be_true
    
    @browser.is_text_present(@place_answer).should be_true
  end
  
  it 'should place user-defined questions on the correct tabs in show mode' do
    assert_tab_contains_question(@browser, PLACE, @place_question_text).should be_true
  end
  
end
  
