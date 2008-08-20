require File.dirname(__FILE__) + '/spec_helper'

#uncomment to kill browser
$dont_kill_browser = true
$sleep_time = 5

describe 'Print CMR page' do
  it 'should correctly display the information to the print page' do
    @browser.open "/trisano/cmrs"
    click_nav_new_cmr(@browser).should be_true
    @browser.type('morbidity_event_active_patient__active_primary_entity__person_last_name', 'Lebowski')
    @browser.type('morbidity_event_active_patient__active_primary_entity__person_first_name', 'Jeffrey')
    @browser.type('morbidity_event_active_patient__active_primary_entity__person_middle_name', '`The Dude`')
    @browser.type('morbidity_event_active_patient__active_primary_entity__address_street_number', '123')
    @browser.type('morbidity_event_active_patient__active_primary_entity__address_street_name', 'Fake Street')
    @browser.type('morbidity_event_active_patient__active_primary_entity__address_city', 'Venice')
    @browser.select('morbidity_event_active_patient__active_primary_entity__address_state_id', 'label=California')
    @browser.select('morbidity_event_active_patient__active_primary_entity__address_county_id', 'label=Out-of-state')
    @browser.type('morbidity_event_active_patient__active_primary_entity__address_postal_code', '12345')
    @browser.type('morbidity_event_active_patient__active_primary_entity__person_birth_date', '4/20/1965')
    @browser.type('morbidity_event_active_patient__active_primary_entity__person_approximate_age_no_birthday', '43')
    @browser.click('link=New Telephone / Email')
    @browser.select('morbidity_event_new_telephone_attributes__entity_location_type_id', 'label=Work')
    @browser.type('morbidity_event_new_telephone_attributes__area_code', '555')
    @browser.type('morbidity_event_new_telephone_attributes__phone_number', '5551345')
    @browser.select('morbidity_event_active_patient__active_primary_entity__person_birth_gender_id', 'label=Male')
    @browser.select('morbidity_event_active_patient__active_primary_entity__person_ethnicity_id', 'label=Not Hispanic or Latino')
    @browser.add_selection('morbidity_event_active_patient__active_primary_entity_race_ids', 'label=White')
    @browser.select('morbidity_event_active_patient__active_primary_entity__person_primary_language_id', 'label=Hmong')
    save_cmr(@browser).should be_true

    @browser.click "edit_cmr_link"
    @browser.wait_for_page_to_load $load_time
    @browser.click "//ul[@id='tabs']/li[2]/a/em"
    @browser.select "morbidity_event_disease_disease_id", "label=Botulism, foodborne"
    @browser.type "morbidity_event_disease_disease_onset_date", "12/12/2002"
    @browser.type "morbidity_event_disease_date_diagnosed", "12/12/2003"
    @browser.click "link=Add a diagnosing facility"
    @browser.select "morbidity_event_new_diagnostic_attributes__secondary_entity_id", "label=American Fork Hospital"
    @browser.click "link=Add a diagnosing facility"
    @browser.select "//div[@id='diagnostics']/div[2]/span[1]/select", "label=CHRISTUS St Joseph Villa"
    @browser.click "link=Add a diagnosing facility"
    @browser.select "//div[@id='diagnostics']/div[3]/span[1]/select", "label=Dixie Regional Medical Center"
    @browser.click "link=Add a diagnosing facility"
    @browser.select "//div[@id='diagnostics']/div[4]/span[1]/select", "label=CHRISTUS St Joseph Villa"
    @browser.click "link=Add a hospital"
    @browser.select "morbidity_event_new_hospital_attributes__secondary_entity_id", "label=Ashley Regional Medical Center"
    @browser.type "morbidity_event_new_hospital_attributes__admission_date", "1/1/1901"
    @browser.type "morbidity_event_new_hospital_attributes__discharge_date", "12/12/2003"
    @browser.type "morbidity_event_new_hospital_attributes__medical_record_number", "7"
    @browser.select "morbidity_event_disease_died_id", "label=Yes"
    @browser.type "morbidity_event_active_patient__active_primary_entity__person_date_of_death", "5/5/2009"
    @browser.select "morbidity_event_active_patient__participations_risk_factor_pregnant_id", "label=Yes"
    @browser.type "morbidity_event_active_patient__participations_risk_factor_pregnancy_due_date", "12/12/2009"
    @browser.click "link=New Treatment"
    sleep($sleep_time)
    @browser.type "participations_treatment_treatment", "White Russian"
    @browser.select "participations_treatment_treatment_given_yn_id", "label=Yes"
    @browser.type "participations_treatment_treatment_date", "1/17/1901"
    @browser.click "treatment-save-button"
    @browser.click "link=New Treatment"
    sleep($sleep_time)
    @browser.type "participations_treatment_treatment", "Bowling"
    @browser.select "participations_treatment_treatment_given_yn_id", "label=No"
    @browser.type "participations_treatment_treatment_date", "1/18/1901"
    @browser.click "treatment-save-button"
    @browser.click "link=New Clinician"
    sleep($sleep_time)
    @browser.type "entity_person_last_name", "Mario"
    @browser.type "entity_person_first_name", "Mario"
    @browser.type "entity_person_middle_name", "A"
    @browser.select "entity_telephone_entities_location_entity_location_type_id", "label=Home"
    @browser.type "entity_telephone_area_code", "555"
    @browser.type "entity_telephone_phone_number", "5551337"
    @browser.type "entity_telephone_extension", "555"
    @browser.type "entity_telephone_email_address", "asd@asd.asd"
    @browser.click "person-save-button"
    @browser.click "link=New Clinician"
    sleep($sleep_time)
    @browser.type "entity_person_last_name", "Luigi"
    @browser.type "entity_person_last_name", "Mario"
    @browser.type "entity_person_first_name", "Luigi"
    @browser.type "entity_person_middle_name", "A"
    @browser.select "entity_telephone_entities_location_entity_location_type_id", "label=Unknown"
    @browser.type "entity_telephone_area_code", "625"
    @browser.type "entity_telephone_phone_number", "5550100"
    @browser.type "entity_telephone_extension", "55"
    @browser.type "entity_telephone_email_address", "qwe@wq.we"
    @browser.click "person-save-button"
    @browser.click "morbidity_event_submit"
    @browser.wait_for_page_to_load $load_time

    @browser.click "edit_cmr_link"
    @browser.wait_for_page_to_load $load_time
    @browser.click "//ul[@id='tabs']/li[3]/a/em"
    @browser.click "link=Add a lab result"
    type_field_by_order(@browser, "model_auto_completer_tf", 0, "Venture Complex")
    @browser.type "morbidity_event_new_lab_attributes__test_type", "Necromancy"
    @browser.type "morbidity_event_new_lab_attributes__lab_result_text", "Zombies"
    @browser.type "morbidity_event_new_lab_attributes__interpretation", "Orpheus Says Oops"
    @browser.select "morbidity_event_new_lab_attributes__specimen_source_id", "label=Blood"
    @browser.type "morbidity_event_new_lab_attributes__collection_date", "12/12/2002"
    @browser.type "morbidity_event_new_lab_attributes__lab_test_date", "12/13/2005"
    @browser.select "morbidity_event_new_lab_attributes__specimen_sent_to_uphl_yn_id", "label=Unknown"
    @browser.click "morbidity_event_submit"
    @browser.wait_for_page_to_load $load_time

    @browser.click "edit_cmr_link"
    @browser.wait_for_page_to_load $load_time
    @browser.click "//ul[@id='tabs']/li[4]/a/em"
    @browser.click "link=Add a contact"
    @browser.type "morbidity_event_new_contact_attributes__last_name", "Nakamura"
    @browser.type "morbidity_event_new_contact_attributes__first_name", "Hiro"
    @browser.click "link=Add a contact"
    @browser.type "//div[@id='contacts']/div[4]/span[1]/input", "Lina"
    @browser.type "//div[@id='contacts']/div[4]/span[2]/input", "Inverse"
    @browser.click "link=Add a contact"
    @browser.type "//div[@id='contacts']/div[6]/span[1]/input", "Steve"
    @browser.type "//div[@id='contacts']/div[6]/span[2]/input", "Jobbs"
    @browser.click "morbidity_event_submit"
    @browser.wait_for_page_to_load $load_time

    @browser.click "edit_cmr_link"
    @browser.wait_for_page_to_load $load_time
    @browser.click "//ul[@id='tabs']/li[5]/a/em"
    @browser.select "morbidity_event_active_patient__participations_risk_factor_food_handler_id", "label=No"
    @browser.select "morbidity_event_active_patient__participations_risk_factor_healthcare_worker_id", "label=Yes"
    @browser.select "morbidity_event_active_patient__participations_risk_factor_group_living_id", "label=No"
    @browser.select "morbidity_event_active_patient__participations_risk_factor_day_care_association_id", "label=Yes"
    @browser.type "morbidity_event_active_patient__participations_risk_factor_occupation", "Unemployed"
    @browser.type "morbidity_event_active_patient__participations_risk_factor_risk_factors", "Nope"
    @browser.type "morbidity_event_active_patient__participations_risk_factor_risk_factors_notes", "Whatever, Man"
    @browser.select "morbidity_event_imported_from_id", "label=Unknown"
    @browser.click "morbidity_event_submit"
    @browser.wait_for_page_to_load $load_time

    @browser.click "edit_cmr_link"
    @browser.wait_for_page_to_load $load_time
    @browser.click "//ul[@id='tabs']/li[6]/a/em"
    type_field_by_order(@browser, "model_auto_completer_tf", 0, "why")
    @browser.type "morbidity_event_active_reporter__active_secondary_entity__person_first_name", "what"
    @browser.type "morbidity_event_active_reporter__active_secondary_entity__person_last_name", "how"
    @browser.select "morbidity_event_active_reporter__active_secondary_entity__telephone_entities_location_entity_location_type_id", "label=Unknown"
    @browser.type "morbidity_event_active_reporter__active_secondary_entity__telephone_area_code", "555"
    @browser.type "morbidity_event_active_reporter__active_secondary_entity__telephone_extension", "555"
    @browser.type "morbidity_event_active_reporter__active_secondary_entity__telephone_phone_number", "5550150"
    @browser.type "morbidity_event_results_reported_to_clinician_date", "12/12/2004"
    @browser.type "morbidity_event_first_reported_PH_date", "12/12/2005"
    @browser.click "morbidity_event_submit"
    @browser.wait_for_page_to_load $load_time

    @browser.click "edit_cmr_link"
    @browser.wait_for_page_to_load $load_time
    @browser.click "//ul[@id='tabs']/li[7]/a/em"
    @browser.select "morbidity_event_lhd_case_status_id", "label=Confirmed"
    @browser.select "morbidity_event_udoh_case_status_id", "label=Not a Case"
    @browser.select "morbidity_event_outbreak_associated_id", "label=Yes"
    @browser.type "morbidity_event_outbreak_name", "POCKET MONSTERS"
    @browser.select "morbidity_event_active_jurisdiction_secondary_entity_id", "label=Central Utah Public Health Department"
    @browser.select "morbidity_event_event_status_id", "label=Accepted by Local Health Dept."
    @browser.type "morbidity_event_investigation_started_date", "12/3/2003"
    @browser.type "morbidity_event_investigation_completed_LHD_date", "12/7/2007"
    @browser.type "morbidity_event_event_name", "Y HELO THAR"
    @browser.type "morbidity_event_review_completed_UDOH_date", "12/5/1963"
    @browser.click "morbidity_event_submit"
    @browser.wait_for_page_to_load $load_time
    @browser.click "link=Print"
    @browser.wait_for_pop_up '_blank', $load_time
    @browser.select_window '_blank'

    @browser.is_text_present('Confidential Case Report').should be_true
    @browser.is_text_present('Lebowski').should be_true
    @browser.is_text_present('Botulism, foodborne').should be_true
    @browser.is_text_present('Lebowski').should be_true
    @browser.is_text_present('Jeffrey').should be_true
    @browser.is_text_present('`The Dude`').should be_true
    @browser.is_text_present('123 Fake Street').should be_true
    @browser.is_text_present('Venice').should be_true
    @browser.is_text_present('California').should be_true
    @browser.is_text_present('Out-of-state').should be_true
    @browser.is_text_present('12345').should be_true
    @browser.is_text_present('1965-04-20').should be_true
    @browser.is_text_present('43').should be_true
    @browser.is_text_present('(555) 555-1345').should be_true
    @browser.is_text_present('Male').should be_true
    @browser.is_text_present('Hmong').should be_true
    @browser.is_text_present('Not Hispanic or Latino').should be_true
    @browser.is_text_present('2002-12-12').should be_true
    @browser.is_text_present('2003-12-12').should be_true
    @browser.is_text_present('Yes').should be_true
    @browser.is_text_present('2009-05-05').should be_true
    @browser.is_text_present('2009-12-12').should be_true
    @browser.is_text_present('Unknown').should be_true
    @browser.is_text_present('American Fork Hospital').should be_true
    @browser.is_text_present('CHRISTUS St Joseph Villa').should be_true
    @browser.is_text_present('Dixie Regional Medical Center').should be_true
    @browser.is_text_present('Ashley Regional Medical Center').should be_true
    @browser.is_text_present('1901-01-01').should be_true
    @browser.is_text_present('2003-12-12').should be_true
    @browser.is_text_present('7').should be_true
    @browser.is_text_present('No').should be_true
    @browser.is_text_present('White Russian').should be_true
    @browser.is_text_present('Bowling').should be_true
    @browser.is_text_present('Mario').should be_true
    @browser.is_text_present('Luigi').should be_true
    @browser.is_text_present('Venture Complex').should be_true
    @browser.is_text_present('Necromancy').should be_true
    @browser.is_text_present('Blood').should be_true
    @browser.is_text_present('Zombies').should be_true
    @browser.is_text_present('Orpheus Says Oops').should be_true
    @browser.is_text_present('2005-12-13').should be_true
    @browser.is_text_present('Nakamura').should be_true
    @browser.is_text_present('Hiro').should be_true
    @browser.is_text_present('Lina').should be_true
    @browser.is_text_present('Inverse').should be_true
    @browser.is_text_present('Steve').should be_true
    @browser.is_text_present('Jobbs').should be_true
    @browser.is_text_present('Unemployed').should be_true
    @browser.is_text_present('Whatever, Man').should be_true
    @browser.is_text_present('what how').should be_true
    @browser.is_text_present('why').should be_true
    @browser.is_text_present('(555) 555-0150 Ext. 555').should be_true
    @browser.is_text_present('2004-12-12').should be_true
    @browser.is_text_present('2005-12-12').should be_true
    @browser.is_text_present('2005').should be_true
    @browser.is_text_present('POCKET MONSTERS').should be_true
    @browser.is_text_present('Y HELO THAR').should be_true
    @browser.is_text_present('Accepted by Local Health Dept.').should be_true
    @browser.is_text_present('2003-12-03').should be_true
    @browser.is_text_present('1963-12-05').should be_true
    @browser.is_text_present('2007-12-07').should be_true
    @browser.is_text_present('Central Utah Public Health Department').should be_true
  end
end