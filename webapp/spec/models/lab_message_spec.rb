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

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../features/support/hl7_messages.rb')

describe LabMessage do
  before(:each) do
    @valid_attributes = {
      :hl7_message => hl7_messages[:arup_1]
    }
  end

  it "should create a new instance given valid attributes" do
    LabMessage.create!(@valid_attributes)
  end

  it "should not be valid if there's no HL7 message" do
    LabMessage.new.should_not be_valid
  end

  it 'should respond to hl7' do
    LabMessage.create!(@valid_attributes).respond_to?(:hl7).should be_true
  end

  describe 'received HL7 2.3 +' do
    
    before :each do
      @lab_message = LabMessage.create(:hl7_message => hl7_messages[:arup_1])
    end

    it 'should return HL7 version' do
      @lab_message.patient_name.should == 'LIN GENYAO     L'
    end

    it 'should return the hl7 version' do
      @lab_message.hl7_version.should == '2.3.1'
    end

  end

  describe 'HL7 2.5 not already handled by HL7 2.3' do
    # nothing here at the moment
  end

  describe 'with invalid HL7' do

    it 'should contain a message header' do
      @lab_message = LabMessage.new(:hl7_message => 'junk')
      @lab_message.should_not be_valid
      @lab_message.errors.on(:hl7_message).should be_true
    end

  end
  
end

