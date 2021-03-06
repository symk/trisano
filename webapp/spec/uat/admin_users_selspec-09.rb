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

# $dont_kill_browser = true

describe 'Managing users' do
  
  it "should allow adding a new user with no roles" do
    @browser.open "/trisano/cmrs"
    current_user = @browser.get_selected_label("user_id")
    if current_user != "default_user"
      switch_user(@browser, "default_user")
    end

    go_to_new_user_page
    uid = get_unique_name(1)+get_unique_name(1)
    uname = get_unique_name(2)
    enter_user_info(uid, uname)
    save_and_verify_user(uid, uname)
    @browser.is_text_present("No roles").should be_true
  end

  it "should allow adding a new user with one role in one jurisdiction" do
    go_to_new_user_page
    uid = get_unique_name(1)+get_unique_name(1)
    uname = get_unique_name(2)
    enter_user_info(uid, uname)

    @browser.click "link=Add Role"
    @browser.select "user_role_membership_attributes__role_id", "label=Administrator"
    @browser.select "user_role_membership_attributes__jurisdiction_id", "label=Bear River Health Department"

    save_and_verify_user(uid, uname)

    @browser.is_text_present("Administrator").should be_true
    @browser.is_text_present("Bear River").should be_true
  end
 
  it "should allow adding a new user with two different roles in one jurisdiction" do
    go_to_new_user_page
    uid = get_unique_name(1)+get_unique_name(1)
    uname = get_unique_name(2)
    enter_user_info(uid, uname)
    add_role(@browser, { :role => "Administrator", :jurisdiction => "TriCounty Health Department" }, 1)
    add_role(@browser, { :role => "Investigator", :jurisdiction => "TriCounty Health Department" }, 2)
    save_and_verify_user(uid, uname)

    @browser.is_text_present("Administrator").should be_true
    @browser.is_text_present("Investigator").should be_true
    num_times_text_appears(@browser, "TriCounty").should == 2
  end

  it "should allow adding a new user with roles in multiple jurisdictions" do
    go_to_new_user_page
    uid = get_unique_name(1)+get_unique_name(1)
    uname = get_unique_name(2)
    enter_user_info(uid, uname)
    add_role(@browser, { :role => "Administrator", :jurisdiction => "Davis County Health Department" }, 1)
    add_role(@browser, { :role => "Investigator", :jurisdiction => "TriCounty Health Department" }, 2)
    save_and_verify_user(uid, uname)
  
    @browser.is_text_present("Administrator").should be_true
    @browser.is_text_present("Investigator").should be_true
    @browser.is_text_present("Davis County").should be_true
    @browser.is_text_present("TriCounty").should be_true
  end
  
  it "should allow adding a role to an existing user" do
    go_to_new_user_page
    uid = get_unique_name(1)+get_unique_name(1)
    uname = get_unique_name(2)
    enter_user_info(uid, uname)
    add_role(@browser, { :role => "Administrator", :jurisdiction => "Bear River Health Department" }, 1)
    save_and_verify_user(uid, uname)
  
    @browser.is_text_present("Administrator").should be_true
    @browser.is_text_present("Bear River").should be_true
  
    @browser.click("link=Edit")
    @browser.wait_for_page_to_load($load_time)
    add_role(@browser, { :role => "Investigator", :jurisdiction => "TriCounty Health Department" }, 2)
    @browser.click "user_submit"
    @browser.wait_for_page_to_load($load_time)
  
    @browser.is_text_present("Administrator").should be_true
    @browser.is_text_present("Investigator").should be_true
    @browser.is_text_present("Bear River").should be_true
    @browser.is_text_present("TriCounty").should be_true
  end
  
  it "should allow deleting all roles of an existing user" do
    go_to_new_user_page
    uid = get_unique_name(1)+get_unique_name(1)
    uname = get_unique_name(2)
    enter_user_info(uid, uname)
    add_role(@browser, { :role => "Administrator", :jurisdiction => "Davis County Health Department" }, 1)
    add_role(@browser, { :role => "Investigator", :jurisdiction => "TriCounty Health Department" }, 2)
    save_and_verify_user(uid, uname)
  
    @browser.is_text_present("Administrator").should be_true
    @browser.is_text_present("Davis").should be_true
    @browser.is_text_present("Investigator").should be_true
    @browser.is_text_present("TriCounty").should be_true
  
    @browser.click("link=Edit")
    @browser.wait_for_page_to_load($load_time)
  
    @browser.click "remove_role_membership_link"
    @browser.click "remove_role_membership_link"
  
    @browser.click "user_submit"
    @browser.wait_for_page_to_load($load_time)
  
    @browser.is_text_present("Administrator").should be_false
    @browser.is_text_present("Investigator").should be_false
    @browser.is_text_present("Davis County").should be_false
    @browser.is_text_present("TriCounty").should be_false
    @browser.is_text_present("No roles").should be_true
  end
end

def go_to_new_user_page
  @browser.open "/trisano/users"
  @browser.wait_for_page_to_load($load_time)
    
  @browser.click "//input[@value='Create new user']"
  @browser.wait_for_page_to_load($load_time)
end

def enter_user_info(uid, uname)
  @browser.type "user_uid", uid
  @browser.type "user_user_name", uname
end

def save_and_verify_user(uid, uname)
  @browser.click "user_submit"
  @browser.wait_for_page_to_load($load_time)
  @browser.is_text_present('User was successfully created.').should be_true
  @browser.is_text_present(uid).should be_true
  @browser.is_text_present(uname).should be_true
end
