require File.dirname(__FILE__) + '/spec_helper'

#$dont_kill_browser = true

describe "Form Builder Investigator Single Form" do
  
  before(:all) do
    @form_name = get_unique_name(4)
    @browser.open "/nedss/cmrs"
    click_nav_forms(@browser)
  end
  
  it "should create a single test form" do
    create_new_form_and_go_to_builder(@browser, @form_name, "Amebiasis", "All Jurisdictions")
  end
  
  it "should add a section to the forms tab" do
    @browser.click "link=Add section to tab"
    #wait_for_element_present("new-section-form")
    sleep 3 #waiting for section text box to load
    @browser.type "section_element_name", "Section 1"
    @browser.click "section_element_submit"
    wait_for_element_not_present("new-section-form")
    @browser.is_text_present("Section 1").should be_true
  end
  
  it "should add a single-line text question to the section" do
    @browser.click "link=Add question to section"
    #wait_for_element_present("new-question-form")
    sleep 3 
    @browser.type "question_element_question_attributes_question_text", "Single-line text"
    @browser.select "question_element_question_attributes_data_type", "label=Single line text"
    @browser.click "question_element_submit"
    wait_for_element_not_present("new-question-form")
    @browser.is_text_present("Question: Single-line text").should be_true
  end
  
  it "should add a multi-line text question to the section" do  
    @browser.click "link=Add question to section"
    wait_for_element_present("new-question-form")
    @browser.type "question_element_question_attributes_question_text", "Multi-line text"
    @browser.select "question_element_question_attributes_data_type", "label=Multi-line text"
    @browser.click "question_element_submit"
    wait_for_element_not_present("new-question-form")
    @browser.is_text_present("Question: Multi-line text").should be_true
  end
  
  it "should add a drop down question to the section" do  
    @browser.click "link=Add question to section"
    wait_for_element_present("new-question-form")
    @browser.type "question_element_question_attributes_question_text", "Drop Down"
    @browser.select "question_element_question_attributes_data_type", "label=Drop-down select list"
    @browser.click "question_element_submit"
    wait_for_element_not_present("new-question-form")
    @browser.is_text_present("Question: Drop Down").should be_true
  end

  it "should add a value set to the drop down question" do    
    @browser.click "link=Add value set"
    wait_for_element_present("new-value-set-form")
    @browser.type "value_set_element_name", "Drop down values"
    @browser.click "link=Add a value"
    @browser.click "link=Add a value"
    @browser.click "link=Add a value"
    wait_for_element_present("value_set_element_new_value_element_attributes__name")
    @browser.type "value_set_element_new_value_element_attributes__name", "Value One"
    @browser.type "document.forms['value-set-element-new-form'].elements['value_set_element[new_value_element_attributes][][name]'][1]", "Value Two"
    @browser.type "document.forms['value-set-element-new-form'].elements['value_set_element[new_value_element_attributes][][name]'][2]", "Value Three"
    @browser.click "value_set_element_submit"
    #wait_for_element_not_present("new-value-set-form")
    sleep 3
    @browser.is_text_present("Value Set: Drop down values").should be_true
    @browser.is_text_present("Value Three").should be_true
    @browser.is_text_present("Value Two").should be_true
    @browser.is_text_present("Value One").should be_true
  end
  
  it "should add a check box question to the section" do
    @browser.click "link=Add question to section"
    wait_for_element_present("new-question-form")
    @browser.type "question_element_question_attributes_question_text", "Check boxes"
    @browser.select "question_element_question_attributes_data_type", "label=Checkboxes"
    @browser.click "question_element_submit"
    wait_for_element_not_present("new-question-form")
    @browser.is_text_present("Question: Check boxes").should be_true
  end
  
  it "should add a value set to the check box question" do
    @browser.click "link=Add value set"
    wait_for_element_present("new-value-set-form")
    @browser.type "value_set_element_name", "Check box values"
    @browser.click "link=Add a value"
    @browser.click "link=Add a value"
    @browser.click "link=Add a value"
    wait_for_element_present("value_set_element_new_value_element_attributes__name")
    @browser.type "value_set_element_new_value_element_attributes__name", "First Value"
    @browser.type "document.forms['value-set-element-new-form'].elements['value_set_element[new_value_element_attributes][][name]'][1]", "Second Value"
    @browser.type "document.forms['value-set-element-new-form'].elements['value_set_element[new_value_element_attributes][][name]'][2]", "Third Value"
    @browser.click "value_set_element_submit"
    wait_for_element_not_present("new-value-set-form")
    @browser.is_text_present("Value Set: Check box values").should be_true    
    @browser.is_text_present("First Value").should be_true
    @browser.is_text_present("Second Value").should be_true
    @browser.is_text_present("Third Value").should be_true
  end
  
  it "should add a drop down question to the section with no answer set" do
    @browser.click "link=Add question to section"
    wait_for_element_present("new-question-form")
    @browser.type "question_element_question_attributes_question_text", "Drop Down with no value set"
    @browser.select "question_element_question_attributes_data_type", "label=Drop-down select list"
    @browser.click "question_element_submit"
    wait_for_element_not_present("new-question-form")
    @browser.is_text_present("Question: Drop Down with no value set").should be_true
  end
  
  it "should add a drop down question to the section with an answer set but no answer values" do
    @browser.click "link=Add question to section"
    wait_for_element_present("new-question-form")
    @browser.type "question_element_question_attributes_question_text", "Drop down with null value set"
    @browser.select "question_element_question_attributes_data_type", "label=Checkboxes"
    @browser.click "question_element_submit"
    wait_for_element_not_present("new-question-form")
    @browser.is_text_present("Question: Drop down with null value set").should be_true
    
    @browser.click "link=Add value set"
    wait_for_element_present("new-value-set-form")
    @browser.type "value_set_element_name", "Value set with no values"
    @browser.click "value_set_element_submit"
    wait_for_element_not_present("new-value-set-form")
    @browser.is_text_present("Value set with no values").should be_true
  end
  
  it "should publish the form" do
    @browser.click "//input[@value='Publish']"
    @browser.wait_for_page_to_load($load_time)
    @browser.is_text_present("Form was successfully published").should be_true
  end

  it "Should create a test CMR" do
    click_nav_new_cmr(@browser)
    @browser.type "morbidity_event_active_patient__active_primary_entity__person_last_name", "Doe"
    @browser.type "morbidity_event_active_patient__active_primary_entity__person_first_name", "John"
    click_core_tab(@browser, "Clinical")
    @browser.select "morbidity_event_disease_disease_id", "label=Amebiasis"
    click_core_tab(@browser, "Administrative")
    @browser.select "morbidity_event_event_status_id", "label=Under Investigation"
    save_cmr(@browser)
    @browser.is_text_present("CMR was successfully created").should be_true
  end

  it "should render the form with all the valid questions" do
    edit_cmr(@browser)
    @browser.click_core_tab(@browser, "Investigation")
    @browser.is_text_present("Investigation").should be_true
    @browser.is_text_present(@form_name).should be_true
    @browser.click("link=" + @form_name)
    @browser.is_text_present("Single-line text").should be_true
    @browser.is_text_present("Multi-line text").should be_true
    @browser.is_text_present("Drop Down").should be_true
    @browser.is_text_present("Check boxes").should be_true
    @browser.is_text_present("First Value").should be_true
    @browser.is_text_present("Second Value").should be_true
    @browser.is_text_present("Third Value").should be_true
    @browser.is_text_present("Drop down with null value set").should be_false
    @browser.is_text_present("Value set with no values").should be_false
  end

  it "should save entered data." do
    pending "until we figure out how to guarantee dynamic field names"
    @browser.click_core_tab(@browser, "Investigation")
    @browser.type "morbidity_event_answers_1_text_answer", "One"
    @browser.type "morbidity_event_answers_2_text_answer", "Two"
    @browser.select "morbidity_event_answers_3_text_answer", "label=Value Three"
    @browser.click "morbidity_event_answers__4_check_box_answer_1"
    @browser.click "morbidity_event_answers__4_check_box_answer_2"
    @browser.click "morbidity_event_answers__4_check_box_answer_3"
    @browser.click "morbidity_event_submit"
    @browser.wait_for_page_to_load($load_time)
    @browser.is_text_present("CMR was successfully updated").should be_true
  end

  it "should maintain values on edit" do
    pending "until we figure out how to guarantee dynamic field names"
    @browser.click "edit_cmr_link"
    @browser.wait_for_page_to_load($load_time)
    @browser.click_core_tab("Investigation")
    @browser.get_value("morbidity_event_answers_1_text_answer").should eql("One")
    @browser.get_value("morbidity_event_answers_2_text_answer").should eql("Two")
    @browser.get_value("morbidity_event_answers_3_text_answer").should eql("Value Three")
    @browser.is_checked("morbidity_event_answers__4_check_box_answer_1").should be_true
    @browser.is_checked("morbidity_event_answers__4_check_box_answer_2").should be_true
    @browser.is_checked("morbidity_event_answers__4_check_box_answer_3").should be_true
  end

end