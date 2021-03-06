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

require File.dirname(__FILE__) + '/../spec_helper'

describe User, "loaded from fixtures" do
  
  fixtures :users, :role_memberships, :roles, :entities, :privileges, :privileges_roles, :entitlements
  
  before(:each) do
    @user = users(:default_user) 
  end

  it "should be valid" do
    @user.should be_valid
  end
  
  it "should be invalid without a UID" do
    @user.uid = ""
    @user.should_not be_valid
  end
  
  it "should be invalid without a user name" do
    @user.user_name = ""
    @user.should_not be_valid
  end
  
  it "should be an admin" do
    @user.is_admin?.should be_true
  end

  it "should have one jurisdiction id for view privilege" do
    @user.jurisdiction_ids_for_privilege(:view_event).size.should eql(1)
  end
  
  it "should have one jurisdiction id for update privilege" do
    @user.jurisdiction_ids_for_privilege(:update_event).size.should eql(1)
  end
  
  it "should have one admin jurisdiction id" do
    @user.admin_jurisdiction_ids.size.should == 1
  end

  describe "getting potential task assignees" do
    it "should find users with update event in the provided jurisdiction" do
      assignees = User.task_assignees_for_jurisdictions(entities(:Southeastern_District).id)
      assignees.size.should == 2

      assignees = User.task_assignees_for_jurisdictions(entities(:Summit_County).id)
      assignees.size.should == 0
    end

    describe 'using default rules for task assignees' do 
      before(:each) do
        @user = users :default_user
        User.current_user = @user
      end

      it 'should return users in jurisdiction where current user has assign_task_to_user rights' do
        User.default_task_assignees.size.should == 2
      end
    end
  end


end

describe User, "Setting role memberships and entitlements via User attributes" do

  fixtures :users, :role_memberships, :roles, :entities, :privileges, :privileges_roles, :entitlements, :entities, :places, :places_types
  
  describe "on a new user" do
    before(:each) do
      @user = User.new( {:user_name => "Joe", :uid => "joe"} )
    end

    describe "assigning one admin role in the Southeastern District" do

      before(:each) do
        @user.attributes = { 
          :role_membership_attributes => [
            { :role_id => roles(:administrator).id, :jurisdiction_id => entities(:Southeastern_District).id }
          ]
        }
      end

      it "should have one role_membership of administrator in the southeastern district" do
        lambda {@user.save}.should change {RoleMembership.count + User.count}.by(2)
        @user.roles.length.should == 1
        @user.roles.first.role_name.should == roles(:administrator).role_name
        @user.role_memberships.length.should == 1
        @user.role_memberships.first.jurisdiction_id.should == entities(:Southeastern_District).id
      end

      it "should be an admin" do
        @user.save
        @user.is_admin?.should be_true
      end
  
      it "should have administrator privileges in Southeastern District" do
        @user.save
        @user.is_entitled_to_in?(:administer, entities(:Southeastern_District).id).should be_true
      end
   
      it "should not have view privileges in Southeastern District" do
        @user.save
        @user.is_entitled_to_in?(:view_event, entities(:Southeastern_District).id).should be_false
      end
 
      it "should not have update privileges in Southeastern District" do
        @user.save
        @user.is_entitled_to_in?(:update_event, entities(:Southeastern_District).id).should be_false
      end
   
      it "should not have a juridiction in the Southeastern District for privilege view" do
        @user.save
        @user.jurisdictions_for_privilege(:view_event).length.should eql(0)
      end
   
      it "should have no jurisdiction id for view privilege" do
        @user.save
        @user.jurisdiction_ids_for_privilege(:view_event).size.should eql(0)
      end
   
      it "should have no jurisdiction id for update privilege" do
        @user.save
        @user.jurisdiction_ids_for_privilege(:update_event).size.should eql(0)
      end
   
      it "should have one jurisdiction id for administer privilege" do
        @user.save
        @user.jurisdiction_ids_for_privilege(:administer).size.should eql(1)
      end

      it "should be possible to call is_entitled_to? with an array and get the right answer" do
        @user.save
        @user.is_entitled_to_in?(:update_event, [entities(:Southeastern_District).id, entities(:Davis_County).id]).should be_false
        @user.is_entitled_to_in?(:update_event, [entities(:Davis_County).id, entities(:Davis_County).id]).should be_false
      end
    end

    describe "assigning one admin role and one investigator role in the Southeastern District" do
      before(:each) do
        @user.attributes = { 
          :role_membership_attributes => [
            { :role_id => roles(:administrator).id, :jurisdiction_id => entities(:Southeastern_District).id },
            { :role_id => roles(:investigator).id, :jurisdiction_id => entities(:Southeastern_District).id }
          ]
        }
      end

      it "should have 2 roles in the southeastern district" do
        lambda {@user.save}.should change {RoleMembership.count + User.count}.by(3)
        @user.roles.length.should == 2
        @user.role_memberships.length.should == 2
        @user.role_memberships[0].jurisdiction_id.should == entities(:Southeastern_District).id
        @user.role_memberships[1].jurisdiction_id.should == entities(:Southeastern_District).id
      end

      it "should be an admin" do
        @user.save
        @user.is_admin?.should be_true
      end
  
      it "should have administrator privileges in Southeastern District" do
        @user.save
        @user.is_entitled_to_in?(:administer, entities(:Southeastern_District).id).should be_true
      end
   
      it "should have view privileges in Southeastern District" do
        @user.save
        @user.is_entitled_to_in?(:view_event, entities(:Southeastern_District).id).should be_true
      end
 
      it "should have update privileges in Southeastern District" do
        @user.save
        @user.is_entitled_to_in?(:update_event, entities(:Southeastern_District).id).should be_true
      end
   
      it "should have a juridiction in the Southeastern District for privilege view" do
        @user.save
        @user.jurisdictions_for_privilege(:view_event).length.should eql(1)
        @user.jurisdictions_for_privilege(:view_event).first.name.should eql(places(:Southeastern_District).name)
      end
   
      it "should have one jurisdiction id for view privilege" do
        @user.save
        @user.jurisdiction_ids_for_privilege(:view_event).size.should eql(1)
      end
   
      it "should have one jurisdiction id for update privilege" do
        @user.save
        @user.jurisdiction_ids_for_privilege(:update_event).size.should eql(1)
      end
   
      it "should have one jurisdiction id for administer privilege" do
        @user.save
        @user.jurisdiction_ids_for_privilege(:administer).size.should eql(1)
      end
    end

    describe "assigning one admin role in the Southeastern District and an investigator role in Davis County" do
      before(:each) do
        @user.attributes = { 
          :role_membership_attributes => [
            { :role_id => roles(:administrator).id, :jurisdiction_id => entities(:Southeastern_District).id },
            { :role_id => roles(:investigator).id, :jurisdiction_id => entities(:Davis_County).id }
          ]
        }
      end

      it "should save properly" do
        lambda {@user.save}.should change {RoleMembership.count + User.count}.by(3)
        @user.roles.length.should == 2
        @user.role_memberships.length.should == 2
        rm_ids = @user.role_memberships.collect { |rm| rm.jurisdiction_id }
        rm_ids.include?(entities(:Southeastern_District).id).should be_true
        rm_ids.include?(entities(:Davis_County).id).should be_true
      end

      it "should be an admin" do
        @user.save
        @user.is_admin?.should be_true
      end
  
      it "should have administrator privileges in Southeastern District" do
        @user.save
        @user.is_entitled_to_in?(:administer, entities(:Southeastern_District).id).should be_true
      end
   
      it "should not have administrator privileges in Southeastern District" do
        @user.save
        @user.is_entitled_to_in?(:administer, entities(:Davis_County).id).should_not be_true
      end

      it "should have view privileges in Southeastern District" do
        @user.save
        @user.is_entitled_to_in?(:view_event, entities(:Southeastern_District).id).should be_false
      end
 
      it "should have view privileges in Davis County" do
        @user.save
        @user.is_entitled_to_in?(:view_event, entities(:Davis_County).id).should be_true
      end
 
      it "should have update privileges in Southeastern District" do
        @user.save
        @user.is_entitled_to_in?(:update_event, entities(:Southeastern_District).id).should be_false
      end
   
      it "should have update privileges in Davis County" do
        @user.save
        @user.is_entitled_to_in?(:update_event, entities(:Davis_County).id).should be_true
      end
   
      it "should have one juridiction for privilege view" do
        @user.save
        @user.jurisdictions_for_privilege(:view_event).length.should eql(1)
        juris = @user.jurisdictions_for_privilege(:view_event).collect { |juri| juri.name }
        juris.include?(places(:Southeastern_District).name).should be_false
        juris.include?(places(:Davis_County).name).should be_true
      end
   
      it "should have two jurisdiction id for update privilege" do
        @user.save
        @user.jurisdiction_ids_for_privilege(:update_event).size.should eql(1)
      end
   
      it "should have one jurisdiction id for administer privilege" do
        @user.save
        @user.jurisdiction_ids_for_privilege(:administer).size.should eql(1)
      end
    end

    describe "assigning one state manager role in the Southeastern District" do

      before(:each) do
        @user.attributes = {
          :role_membership_attributes => [
            { :role_id => roles(:state_manager).id, :jurisdiction_id => entities(:Southeastern_District).id }
          ]
        }
      end

      it "should have one role_membership of state manager in the southeastern district" do
        lambda {@user.save}.should change {RoleMembership.count + User.count}.by(2)
        @user.roles.length.should == 1
        @user.roles.first.role_name.should == roles(:state_manager).role_name
        @user.role_memberships.length.should == 1
        @user.role_memberships.first.jurisdiction_id.should == entities(:Southeastern_District).id
      end

      it "should not be an admin" do
        @user.save
        @user.is_admin?.should be_false
      end

      it "should not have administrator privileges in Southeastern District" do
        @user.save
        @user.is_entitled_to_in?(:administer, entities(:Southeastern_District).id).should be_false
      end

      it "should have view privileges in Southeastern District" do
        @user.save
        @user.is_entitled_to_in?(:view_event, entities(:Southeastern_District).id).should be_true
      end

      it "should have update privileges in Southeastern District" do
        @user.save
        @user.is_entitled_to_in?(:update_event, entities(:Southeastern_District).id).should be_true
      end

      it "should have create privileges in Southeastern District" do
        @user.save
        @user.is_entitled_to_in?(:create_event, entities(:Southeastern_District).id).should be_true
      end

      it "should have approve_event_at_state privileges in Southeastern District" do
        @user.save
        @user.is_entitled_to_in?(:approve_event_at_state, entities(:Southeastern_District).id).should be_true
      end

      it "should have route_event_to_any_lhd privileges in Southeastern District" do
        @user.save
        @user.is_entitled_to_in?(:route_event_to_any_lhd, entities(:Southeastern_District).id).should be_true
      end

      it "should have route_event_to_any_lhd privileges in Southeastern District" do
        @user.save
        @user.is_entitled_to_in?(:assign_task_to_user, entities(:Southeastern_District).id).should be_true
      end

      it "should have assign_task_to_user privileges in Southeastern District" do
        @user.save
        @user.is_entitled_to_in?(:assign_task_to_user, entities(:Southeastern_District).id).should be_true
      end

      it "should have a juridiction in the Southeastern District for privilege view" do
        @user.save
        @user.jurisdictions_for_privilege(:view_event).length.should eql(1)
      end

      it "should have a jurisdiction id for view privilege" do
        @user.save
        @user.jurisdiction_ids_for_privilege(:view_event).size.should eql(1)
      end

      it "should have a jurisdiction id for update privilege" do
        @user.save
        @user.jurisdiction_ids_for_privilege(:update_event).size.should eql(1)
      end

      it "should have no jurisdiction id for administer privilege" do
        @user.save
        @user.jurisdiction_ids_for_privilege(:administer).size.should eql(0)
      end

      it "should be possible to call is_entitled_to? with an array and get the right answer" do
        @user.save
        @user.is_entitled_to_in?(:update_event, [entities(:Southeastern_District).id, entities(:Davis_County).id]).should be_true
        @user.is_entitled_to_in?(:update_event, [entities(:Davis_County).id, entities(:Davis_County).id]).should be_false
      end
      
    end
    
    describe "assigning one LHD manager role in the Southeastern District" do

      before(:each) do
        @user.attributes = {
          :role_membership_attributes => [
            { :role_id => roles(:lhd_manager).id, :jurisdiction_id => entities(:Southeastern_District).id }
          ]
        }
      end

      it "should have one role_membership of LHD manager in the southeastern district" do
        lambda {@user.save}.should change {RoleMembership.count + User.count}.by(2)
        @user.roles.length.should == 1
        @user.roles.first.role_name.should == roles(:lhd_manager).role_name
        @user.role_memberships.length.should == 1
        @user.role_memberships.first.jurisdiction_id.should == entities(:Southeastern_District).id
      end

      it "should not be an admin" do
        @user.save
        @user.is_admin?.should be_false
      end

      it "should not have administrator privileges in Southeastern District" do
        @user.save
        @user.is_entitled_to_in?(:administer, entities(:Southeastern_District).id).should be_false
      end

      it "should have view privileges in Southeastern District" do
        @user.save
        @user.is_entitled_to_in?(:view_event, entities(:Southeastern_District).id).should be_true
      end

      it "should have update privileges in Southeastern District" do
        @user.save
        @user.is_entitled_to_in?(:update_event, entities(:Southeastern_District).id).should be_true
      end

      it "should have create privileges in Southeastern District" do
        @user.save
        @user.is_entitled_to_in?(:create_event, entities(:Southeastern_District).id).should be_true
      end

      it "should have approve_event_at_lhd privileges in Southeastern District" do
        @user.save
        @user.is_entitled_to_in?(:approve_event_at_lhd, entities(:Southeastern_District).id).should be_true
      end

      it "should have route_event_to_any_lhd privileges in Southeastern District" do
        @user.save
        @user.is_entitled_to_in?(:route_event_to_any_lhd, entities(:Southeastern_District).id).should be_true
      end

      it "should have assign_task_to_user privileges in Southeastern District" do
        @user.save
        @user.is_entitled_to_in?(:assign_task_to_user, entities(:Southeastern_District).id).should be_true
      end
      
      it "should have a juridiction in the Southeastern District for privilege view" do
        @user.save
        @user.jurisdictions_for_privilege(:view_event).length.should eql(1)
      end

      it "should have a jurisdiction id for view privilege" do
        @user.save
        @user.jurisdiction_ids_for_privilege(:view_event).size.should eql(1)
      end

      it "should have a jurisdiction id for update privilege" do
        @user.save
        @user.jurisdiction_ids_for_privilege(:update_event).size.should eql(1)
      end

      it "should have no jurisdiction id for administer privilege" do
        @user.save
        @user.jurisdiction_ids_for_privilege(:administer).size.should eql(0)
      end

      it "should be possible to call is_entitled_to? with an array and get the right answer" do
        @user.save
        @user.is_entitled_to_in?(:update_event, [entities(:Southeastern_District).id, entities(:Davis_County).id]).should be_true
        @user.is_entitled_to_in?(:update_event, [entities(:Davis_County).id, entities(:Davis_County).id]).should be_false
      end

    end

    describe "assigning one surveillance manager role in the Southeastern District" do

      before(:each) do
        @user.attributes = {
          :role_membership_attributes => [
            { :role_id => roles(:surveillance_manager).id, :jurisdiction_id => entities(:Southeastern_District).id }
          ]
        }
      end

      it "should have one role_membership of LHD manager in the southeastern district" do
        lambda {@user.save}.should change {RoleMembership.count + User.count}.by(2)
        @user.roles.length.should == 1
        @user.roles.first.role_name.should == roles(:surveillance_manager).role_name
        @user.role_memberships.length.should == 1
        @user.role_memberships.first.jurisdiction_id.should == entities(:Southeastern_District).id
      end

      it "should not be an admin" do
        @user.save
        @user.is_admin?.should be_false
      end

      it "should not have administrator privileges in Southeastern District" do
        @user.save
        @user.is_entitled_to_in?(:administer, entities(:Southeastern_District).id).should be_false
      end

      it "should have view privileges in Southeastern District" do
        @user.save
        @user.is_entitled_to_in?(:view_event, entities(:Southeastern_District).id).should be_true
      end

      it "should have update privileges in Southeastern District" do
        @user.save
        @user.is_entitled_to_in?(:update_event, entities(:Southeastern_District).id).should be_true
      end

      it "should have create privileges in Southeastern District" do
        @user.save
        @user.is_entitled_to_in?(:create_event, entities(:Southeastern_District).id).should be_true
      end

      it "should have accept_event_for_lhd privileges in Southeastern District" do
        @user.save
        @user.is_entitled_to_in?(:accept_event_for_lhd, entities(:Southeastern_District).id).should be_true
      end

      it "should have route_event_to_any_lhd privileges in Southeastern District" do
        @user.save
        @user.is_entitled_to_in?(:route_event_to_any_lhd, entities(:Southeastern_District).id).should be_true
      end
      
      it "should have route_event_to_investigator privileges in Southeastern District" do
        @user.save
        @user.is_entitled_to_in?(:route_event_to_investigator, entities(:Southeastern_District).id).should be_true
      end

      it "should have assign_task_to_user privileges in Southeastern District" do
        @user.save
        @user.is_entitled_to_in?(:assign_task_to_user, entities(:Southeastern_District).id).should be_true
      end
      
      it "should have a juridiction in the Southeastern District for privilege view" do
        @user.save
        @user.jurisdictions_for_privilege(:view_event).length.should eql(1)
      end

      it "should have a jurisdiction id for view privilege" do
        @user.save
        @user.jurisdiction_ids_for_privilege(:view_event).size.should eql(1)
      end

      it "should have a jurisdiction id for update privilege" do
        @user.save
        @user.jurisdiction_ids_for_privilege(:update_event).size.should eql(1)
      end

      it "should have no jurisdiction id for administer privilege" do
        @user.save
        @user.jurisdiction_ids_for_privilege(:administer).size.should eql(0)
      end

      it "should be possible to call is_entitled_to? with an array and get the right answer" do
        @user.save
        @user.is_entitled_to_in?(:update_event, [entities(:Southeastern_District).id, entities(:Davis_County).id]).should be_true
        @user.is_entitled_to_in?(:update_event, [entities(:Davis_County).id, entities(:Davis_County).id]).should be_false
      end

    end

    describe "assigning the same role and jurisdiction twice" do
      before(:each) do
        @user.attributes = { 
          :role_membership_attributes => [
            { :role_id => roles(:administrator).id, :jurisdiction_id => entities(:Davis_County).id },
            { :role_id => roles(:administrator).id, :jurisdiction_id => entities(:Davis_County).id }
          ]
        }
      end

      it "should save properly" do
        lambda {@user.save}.should change {RoleMembership.count + User.count}.by(2)
        @user.roles.length.should == 1
        @user.role_memberships.length.should == 1
        @user.role_memberships[0].jurisdiction_id.should == entities(:Davis_County).id
      end
    end
  end

  describe "on an existing user" do
    before(:each) do
      @user = users(:default_user)
    end

    describe "adding a new role in a new jurisdiction" do
      before(:each) do
        @user.attributes = { 
          :role_membership_attributes => [
            { :role_id => @user.role_memberships.first.role_id, :jurisdiction_id => @user.role_memberships.first.jurisdiction_id},
            { :role_id => roles(:investigator).id, :jurisdiction_id => entities(:Davis_County).id }
          ]
        }
      end

      it "should save properly" do
        @user.save
        @user.role_memberships.length.should == 2
        rm_ids = @user.role_memberships.collect { |rm| rm.jurisdiction_id }
        rm_ids.include?(entities(:Southeastern_District).id).should be_true
        rm_ids.include?(entities(:Davis_County).id).should be_true
      end
    end

    describe "removing all existing roles" do
      before(:each) do
        @user.attributes = { 
          :role_membership_attributes => {}
        }
      end

      it "should save properly" do
        @user.roles.length.should == 0
        @user.role_memberships.length.should == 0
      end
    end

    describe "removing one of two roles" do
      before(:each) do
        @user.attributes = { 
          :role_membership_attributes => [
            { :role_id => @user.role_memberships.first.role_id, :jurisdiction_id => @user.role_memberships.first.jurisdiction_id},
            { :role_id => roles(:investigator).id, :jurisdiction_id => entities(:Davis_County).id }
          ]
        }
        @user.save
      end

      it "should first have two roles" do
        @user.roles.length.should == 2
        @user.role_memberships.length.should == 2
      end

      it "should have one role after deleting the other" do
        @user.attributes = { 
          :role_membership_attributes => [
            { :role_id => roles(:investigator).id, :jurisdiction_id => entities(:Davis_County).id }
          ]
        }
        @user.save
        @user.roles.length.should == 1
        @user.role_memberships.length.should == 1
      end
    end
  end
end

describe User, 'task view settings' do
  
  before(:each) do
    @user = User.create(:uid => 'tu', :user_name => 'taskowner')
  end

  it 'should default to showing only today\'s tasks' do
    @user.task_view_settings.should == {:look_back => 0, :look_ahead => 0}
  end
  
  it 'should store :days_back settings' do
    @user.task_view_settings = {:days_back => 3}
    @user.save!
    @user.task_view_settings.should == {:days_back => 3}
  end

  describe '#store_as_task_view_settings' do
    it 'should reset to default settings w/  nil' do
      @user.store_as_task_view_settings(nil)
      @user.reload
      @user.task_view_settings.should == {:look_back => 0, :look_ahead => 0}
    end

    it 'should only store values that are meaningful as view settings' do
      settings_hash = {
        :look_ahead => 0, 
        :look_back => 0, 
        :disease_filter => [0, 1],
        :junk_value => 0,
        :tasks_ordered_by => :due_date}
      @user.store_as_task_view_settings(settings_hash)
      @user.task_view_settings.should == {
        :look_ahead => 0,
        :look_back => 0,
        :disease_filter => [0, 1], 
        :tasks_ordered_by => :due_date}
    end
      

    it 'should treat an empty hash as default settings' do
      @user.store_as_task_view_settings({})
      @user.reload
      @user.task_view_settings.should == {:look_back => 0, :look_ahead => 0}
    end
  end
  
end

