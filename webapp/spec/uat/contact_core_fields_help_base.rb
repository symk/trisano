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
require 'yaml'

describe "help text for all contact core fields", :shared => true do
  # $dont_kill_browser = true
  
  before :all do
    @browser.open '/trisano/core_fields'
  end

  $test_core_fields.each do |core_field|
    it "should edit #{core_field['event_type']} core field help text for #{core_field['name']}" do
      puts core_field['name']
      @browser.click("//div[@id='rot'][2]//a[text()='#{core_field['name']}']")
      @browser.wait_for_page_to_load
      @browser.click("link=Edit")
      @browser.wait_for_page_to_load
      @browser.type "core_field_help_text", "#{core_field['name']} help"
      @browser.click '//input[@value="Update"]'
      @browser.wait_for_page_to_load
      @browser.is_text_present('Core field was successfully updated').should be_true
    end 

    it "should navigate to a contact edit view" do
      create_basic_investigatable_cmr(@browser, 'Biel', 'Lead poisoning', 'Bear River Health Department')
      edit_cmr(@browser).should be_true
      add_contact(@browser, {:last_name => 'Davies', :first_name => "John", :disposition => "Unable to locate"})
      save_cmr(@browser).should be_true
      click_link_by_order(@browser, "edit-contact-event", 1)
      @browser.wait_for_page_to_load($load_time)
    end
              
    it "should have #{core_field['event_type']} help bubble after #{core_field['name']}" do
      assert_tooltip_exists(@browser, "#{core_field['name']} help").should be_true
      @browser.click("link=ADMIN")
      @browser.wait_for_page_to_load
      @browser.click("admin_help_text")
      @browser.wait_for_page_to_load
    end
      
  end
end
