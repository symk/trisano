require File.dirname(__FILE__) + '/spec_helper'
describe 'User functionality for creating and saving CMRs' do
  
  $dont_kill_browser = true
  
  before(:all) do
    @last_name = get_unique_name(1)
    @browser.open "/nedss/cmrs"
  end
  
  it 'should save a CMR with just a last name' do
    click_nav_new_cmr(@browser).should be_true
    @browser.type('morbidity_event_active_patient__active_primary_entity__person_last_name', @last_name)
    save_cmr(@browser).should be_true
    @browser.is_text_present(@last_name).should be_true
  end
  
  it 'should save the contact information' do
    edit_cmr(@browser).should be_true
    click_core_tab(@browser, "Contacts")
    @browser.click "link=Add a contact"
    sleep(1)
    @browser.type "//div[@class='contact'][1]//input[contains(@id, 'last_name')]", "Costello"
    save_cmr(@browser).should be_true
    @browser.is_text_present('Costello').should be_true
  end
  
  it 'should save the street name' do    
    edit_cmr(@browser).should be_true
    click_core_tab(@browser, "Demographics")
    @browser.type('morbidity_event_active_patient__active_primary_entity__address_street_name', 'Junglewood Court')
             
    save_cmr(@browser).should be_true
  end
  
  it 'should save the phone number' do
    edit_cmr(@browser).should be_true
    @browser.click 'link=New Telephone / Email'
    @browser.select 'morbidity_event_new_telephone_attributes__entity_location_type_id', 'label=Work'
    @browser.type 'morbidity_event_new_telephone_attributes__area_code',   '801'
    @browser.type 'morbidity_event_new_telephone_attributes__phone_number', '5811234'
    save_cmr(@browser).should be_true
  end
  
  it 'should save the disease info' do
    edit_cmr(@browser).should be_true
    click_core_tab(@browser, "Clinical")
    @browser.select 'morbidity_event_disease_disease_id', 'label=AIDS'
    save_cmr(@browser).should be_true
  end
  
  it 'should save the lab result' do
    edit_cmr(@browser).should be_true
    click_core_tab(@browser, "Laboratory")
    @browser.click("link=Add a lab result")
    sleep 3
    @browser.type('model_auto_completer_tf', 'Lab')
    @browser.type('morbidity_event_new_lab_attributes__lab_result_text', 'Positive')
    @browser.select 'morbidity_event_new_lab_attributes__specimen_source_id', 'label=Animal head'
    save_cmr(@browser).should be_true
    @browser.is_text_present('Animal head').should be_true
    @browser.is_text_present('Positive').should be_true
  end
  
  it 'should save the treatment info' do
    edit_cmr(@browser).should be_true
    click_core_tab(@browser, "Clinical")
    @browser.click("link=New Treatment")
    sleep 3
    @browser.select 'participations_treatment_treatment_given_yn_id', 'label=Yes'
    @browser.type('participations_treatment_treatment', 'Leaches')
    @browser.click 'treatment-save-button'
    sleep 3
    save_cmr(@browser).should be_true
  end
  
  it 'should save the reporting info' do
    edit_cmr(@browser).should be_true
    click_core_tab(@browser, "Reporting")
    @browser.type 'model_auto_completer_tf', 'Happy Jacks Health Store'
    save_cmr(@browser).should be_true
  end

  it 'should save administrative info' do
    edit_cmr(@browser).should be_true
    click_core_tab(@browser, "Administrative")
    @browser.select 'morbidity_event_active_jurisdiction_secondary_entity_id', 'label=Salt Lake Valley Health Department'
    save_cmr(@browser).should be_true
  end
  
  it 'should still have all the data present' do
    @browser.is_text_present(@last_name).should be_true
    @browser.is_text_present('Junglewood Court').should be_true
    @browser.is_text_present('(801) 581-1234').should be_true
    
    click_core_tab(@browser, "Clinical")
    @browser.is_text_present('AIDS').should be_true
    @browser.is_text_present('Leaches').should be_true
    
    click_core_tab(@browser, "Laboratory")
    @browser.is_text_present('Animal head').should be_true
    
    click_core_tab(@browser, "Administrative")
    @browser.is_text_present('Salt Lake Valley Health Department').should be_true
    
    click_core_tab(@browser, "Contacts")
    @browser.is_text_present('Smurfette').should be_true
  end
end