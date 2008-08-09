class ParticipationsRacesKeys < ActiveRecord::Migration

   def self.up
	#	
	# this is to bring the database up to the January 21, 2008 design.
	#
	# Table: cases_events
	#   This table is a rename of event_cases to follow the standards of alphabetic names.
	rename_table :event_cases, :cases_events
	
	# Table: hospitals_participations
	#   Rename participation_hospitals to hospitals_particiaptions to follow the standards of alphabetic names.
	rename_table :participation_hospitals, :hospitals_participations
	
	# Table: participations
	#   Change the event_ids to entity_ids
	rename_column :participations, :primary_event_id, :primary_entity_id
	rename_column :participations, :secondary_event_id, :secondary_entity_id
        add_column :participations, :event_id, :integer
	
	# Now add the FK constraints
        #
	execute "ALTER TABLE addresses
		ADD CONSTRAINT  fk_city FOREIGN KEY (city_id) REFERENCES codes(id)"
	execute "ALTER TABLE addresses
		ADD CONSTRAINT  fk_county FOREIGN KEY (county_id) REFERENCES codes(id)"
	
	execute "ALTER TABLE addresses
		ADD CONSTRAINT  fk_district FOREIGN KEY (district_id) REFERENCES codes(id)"
	
	execute "ALTER TABLE addresses
		ADD CONSTRAINT  fk_state FOREIGN KEY (state_id) REFERENCES codes(id)"
	
	execute "ALTER TABLE addresses
		ADD CONSTRAINT  R_1 FOREIGN KEY (location_id) REFERENCES locations(id)"
	
	execute "ALTER TABLE animals
		ADD CONSTRAINT  Is_animal_Entity FOREIGN KEY (entity_id) REFERENCES entities(id)"
	
	execute "ALTER TABLE cases_events
		ADD CONSTRAINT  fk_event_case FOREIGN KEY (event_id) REFERENCES events(id)"
	
	execute "ALTER TABLE clinicals
		ADD CONSTRAINT  fk_event_clinical FOREIGN KEY (event_id) REFERENCES events(id)"
	
	execute "ALTER TABLE clinicals
		ADD CONSTRAINT  fk_lab_yn FOREIGN KEY (test_public_health_lab_id) REFERENCES codes(id)"
	
	execute "ALTER TABLE clusters
		ADD CONSTRAINT  fk_primary_event_cluster FOREIGN KEY (primary_event_id) REFERENCES events(id)"
	
	execute "ALTER TABLE clusters
		ADD CONSTRAINT  fk_secondary_event_cluster FOREIGN KEY (secondary_event_id) REFERENCES events(id)"
	
	execute "ALTER TABLE clusters
		ADD CONSTRAINT  fk_cluster_status FOREIGN KEY (cluster_status_id) REFERENCES codes(id)"
	
	execute "ALTER TABLE disease_events
		ADD CONSTRAINT  fk_event FOREIGN KEY (event_id) REFERENCES events(id)"
	
	execute "ALTER TABLE disease_events
		ADD CONSTRAINT  fk_disease FOREIGN KEY (disease_id) REFERENCES diseases(id)"
	
	execute "ALTER TABLE disease_events
		ADD CONSTRAINT  fk_hospitalized FOREIGN KEY (hospitalized_id) REFERENCES codes(id)"
	
	execute "ALTER TABLE disease_events
		ADD CONSTRAINT  fk_died FOREIGN KEY (died_id) REFERENCES codes(id)"
	
	execute "ALTER TABLE disease_events
		ADD CONSTRAINT  fk_pregnant FOREIGN KEY (pregnant_id) REFERENCES codes(id)"
	
	execute "ALTER TABLE encounters
		ADD CONSTRAINT  fk_event_encounter FOREIGN KEY (event_id) REFERENCES events(id)"
	
	execute "ALTER TABLE entity_groups
		ADD CONSTRAINT  fk_PrimaryEntityId FOREIGN KEY (primary_entity_id) REFERENCES entities(id)"
	
	execute "ALTER TABLE entity_groups
		ADD CONSTRAINT  fk_SecondaryEntityId FOREIGN KEY (secondary_entity_id) REFERENCES entities(id)"
	
	execute "ALTER TABLE entity_groups
		ADD CONSTRAINT  fk_entitygrouptypecode FOREIGN KEY (entity_group_type_id) REFERENCES codes(id)"
	
	execute "ALTER TABLE entities_locations
		ADD CONSTRAINT  fk_location FOREIGN KEY (location_id) REFERENCES locations(id)"
	
	execute "ALTER TABLE entities_locations
		ADD CONSTRAINT  fk_entity FOREIGN KEY (entity_id) REFERENCES entities(id)"
	
	execute "ALTER TABLE entities_locations
		ADD CONSTRAINT  fk_location_type FOREIGN KEY (entity_location_type_id) REFERENCES codes(id)"
	
	execute "ALTER TABLE entities_locations
		ADD CONSTRAINT  fk_Primary_YN FOREIGN KEY (Primary_yn_id) REFERENCES codes(id)"
	
	execute "ALTER TABLE events
		ADD CONSTRAINT  fk_event_type FOREIGN KEY (event_type_id) REFERENCES codes(id)"
	
	execute "ALTER TABLE events
		ADD CONSTRAINT  fk_event_status FOREIGN KEY (event_status_id) REFERENCES codes(id)"
	
	execute "ALTER TABLE events
		ADD CONSTRAINT  fk_event_case_status FOREIGN KEY (event_case_status_id) REFERENCES codes(id)"
	
	execute "ALTER TABLE events
		ADD CONSTRAINT  fk_imported_from FOREIGN KEY (imported_from_id) REFERENCES codes(id)"
	
	execute "ALTER TABLE hospitals_participations
		ADD CONSTRAINT  fk_participation FOREIGN KEY (participation_id) REFERENCES participations(id)"
	
	execute "ALTER TABLE materials
		ADD CONSTRAINT  Is_material_Entity FOREIGN KEY (entity_id) REFERENCES entities(id)"
	
	execute "ALTER TABLE observations
		ADD CONSTRAINT  fk_event_observation FOREIGN KEY (event_id) REFERENCES events(id)"
	
	execute "ALTER TABLE participations
		ADD CONSTRAINT  fk_role FOREIGN KEY (role_id) REFERENCES codes(id)"
	
	execute "ALTER TABLE participations
		ADD CONSTRAINT  fk_participation_status FOREIGN KEY (participation_status_id) REFERENCES codes(id)"
	
	execute "ALTER TABLE participations
		ADD CONSTRAINT  R_3 FOREIGN KEY (primary_entity_id) REFERENCES entities(id)"
	
	execute "ALTER TABLE participations
		ADD CONSTRAINT  R_4 FOREIGN KEY (secondary_entity_id) REFERENCES entities(id)"
	
	execute "ALTER TABLE participations
		ADD CONSTRAINT  R_5 FOREIGN KEY (event_id) REFERENCES events(id)"
	
	execute "ALTER TABLE people
		ADD CONSTRAINT  Is_Person_Entity FOREIGN KEY (entity_id) REFERENCES entities(id)"
	
	execute "ALTER TABLE people
		ADD CONSTRAINT  fk_code_birthgender FOREIGN KEY (birth_gender_id) REFERENCES codes(id)"
	
	execute "ALTER TABLE people
		ADD CONSTRAINT  fk_current_gender FOREIGN KEY (current_gender_id) REFERENCES codes(id)"
	
	execute "ALTER TABLE people
		ADD CONSTRAINT  fk_ethnicity FOREIGN KEY (ethnicity_id) REFERENCES codes(id)"
	
	execute "ALTER TABLE people
		ADD CONSTRAINT  fk_primary_language FOREIGN KEY (primary_language_id) REFERENCES codes(id)"

	execute "ALTER TABLE places
		ADD CONSTRAINT  Is_place_Entity FOREIGN KEY (entity_id) REFERENCES entities(id)"
	
	execute "ALTER TABLE referrals
		ADD CONSTRAINT  fk_event_referral FOREIGN KEY (event_id) REFERENCES events(id)"
	
	execute "ALTER TABLE telephones
		ADD CONSTRAINT  R_2 FOREIGN KEY (location_id) REFERENCES locations(id)"
	
	execute "ALTER TABLE treatments
		ADD CONSTRAINT  fk_treatment_type FOREIGN KEY (treatment_type_id) REFERENCES codes(id)"
	
	execute "ALTER TABLE participations_treatments
		ADD CONSTRAINT  fk_participation_id FOREIGN KEY (participation_id) REFERENCES participations(id)"
	
	execute "ALTER TABLE participations_treatments
		ADD CONSTRAINT  fk_treatment_id FOREIGN KEY (treatment_id) REFERENCES treatments(id)"
	
	execute "ALTER TABLE participations_treatments
		ADD CONSTRAINT  fk_treatment_given_yn FOREIGN KEY (treatment_given_yn_id) REFERENCES codes(id)"
	
   end  

   def self.down
     
     
     rename_column :participations, :primary_entity_id, :primary_event_id 
     rename_column :participations,  :secondary_entity_id, :secondary_event_id

      # Now add the FK constraints
	execute "ALTER TABLE addresses
		DROP CONSTRAINT  fk_city;"
	execute "ALTER TABLE addresses
		DROP CONSTRAINT  fk_county ;"
	
	execute "ALTER TABLE addresses
		DROP CONSTRAINT  fk_district;"
	
	execute "ALTER TABLE addresses
		DROP CONSTRAINT  fk_state;"
	
	execute "ALTER TABLE addresses
		DROP CONSTRAINT  R_1 ;"
	
	execute "ALTER TABLE animals
		DROP CONSTRAINT  Is_animal_Entity;"
	
	execute "ALTER TABLE cases_events
		DROP CONSTRAINT  fk_event_case;"
     
  
	
	execute "ALTER TABLE clinicals
		DROP CONSTRAINT  fk_event_clinical;"
	
	execute "ALTER TABLE clinicals
		DROP CONSTRAINT  fk_lab_yn;"
	
	execute "ALTER TABLE clusters
		DROP CONSTRAINT  fk_primary_event_cluster;"
	
	execute "ALTER TABLE clusters
		DROP CONSTRAINT  fk_secondary_event_cluster;"
	
	execute "ALTER TABLE clusters
		DROP CONSTRAINT  fk_cluster_status;"
	
	execute "ALTER TABLE disease_events
		DROP CONSTRAINT  fk_event;"
	
	execute "ALTER TABLE disease_events
		DROP CONSTRAINT  fk_disease;"
	
	execute "ALTER TABLE disease_events
		DROP CONSTRAINT  fk_hospitalized;"
	
	execute "ALTER TABLE disease_events
		DROP CONSTRAINT  fk_died;"
	
	execute "ALTER TABLE disease_events
		DROP CONSTRAINT  fk_pregnant;"
	
	execute "ALTER TABLE encounters
		DROP CONSTRAINT  fk_event_encounter;"
	
	execute "ALTER TABLE entity_groups
		DROP CONSTRAINT  fk_PrimaryEntityId;"
	
	execute "ALTER TABLE entity_groups
		DROP CONSTRAINT  fk_SecondaryEntityId;"
	
	execute "ALTER TABLE entity_groups
		DROP CONSTRAINT  fk_entitygrouptypecode;"
	
	execute "ALTER TABLE entities_locations
		DROP CONSTRAINT  fk_location;"
	
	execute "ALTER TABLE entities_locations
		DROP CONSTRAINT  fk_entity;"
	
	execute "ALTER TABLE entities_locations
		DROP CONSTRAINT  fk_location_type;"
	
	execute "ALTER TABLE entities_locations
		DROP CONSTRAINT  fk_Primary_YN;"
	
	execute "ALTER TABLE events
		DROP CONSTRAINT  fk_event_type;"
	
	execute "ALTER TABLE events
		DROP CONSTRAINT  fk_event_status;"
	
	execute "ALTER TABLE events
		DROP CONSTRAINT  fk_event_case_status;"
	
	execute "ALTER TABLE events
		DROP CONSTRAINT  fk_imported_from;"
	
	execute "ALTER TABLE hospitals_participations
		DROP CONSTRAINT  fk_participation;"
     
  
	
	execute "ALTER TABLE materials
		DROP CONSTRAINT  Is_material_Entity;"
	
	execute "ALTER TABLE observations
		DROP CONSTRAINT  fk_event_observation;"
	
	execute "ALTER TABLE participations
		DROP CONSTRAINT  fk_role;"
	
	execute "ALTER TABLE participations
		DROP CONSTRAINT  fk_participation_status;"

	execute "ALTER TABLE participations
		DROP CONSTRAINT  R_3;"

	execute "ALTER TABLE participations
		DROP CONSTRAINT  R_4;"
	
	execute "ALTER TABLE participations
		DROP CONSTRAINT  R_5;"
	
	execute "ALTER TABLE people
		DROP CONSTRAINT  Is_Person_Entity;"
	
	execute "ALTER TABLE people
		DROP CONSTRAINT  fk_code_birthgender;"
	
	execute "ALTER TABLE people
		DROP CONSTRAINT  fk_current_gender;"
	
	execute "ALTER TABLE people
		DROP CONSTRAINT  fk_ethnicity;"
	
	# execute "ALTER TABLE people DROP CONSTRAINT  fk_race;"
	
	execute "ALTER TABLE people
		DROP CONSTRAINT  fk_primary_language;"
	
	execute "ALTER TABLE places
		DROP CONSTRAINT  Is_place_Entity;"
	
	execute "ALTER TABLE referrals
		DROP CONSTRAINT  fk_event_referral;"
	
	execute "ALTER TABLE telephones
		DROP CONSTRAINT  R_2;"
	
	execute "ALTER TABLE treatments
		DROP CONSTRAINT  fk_treatment_type;"
	
	execute "ALTER TABLE participations_treatments
		DROP CONSTRAINT  fk_participation_id;"
	
	execute "ALTER TABLE participations_treatments
		DROP CONSTRAINT  fk_treatment_id;"
	
	execute "ALTER TABLE participations_treatments
		DROP CONSTRAINT  fk_treatment_given_yn;"
  
  rename_table :cases_events, :event_cases
  rename_table :hospitals_participations, :participation_hospitals
  
     
   end
end