require 'inferno/dsl/oauth_credentials'
require 'us_core_test_kit/version'
require 'us_core_test_kit/custom_groups/v3.1.1/capability_statement_group'
require 'us_core_test_kit/custom_groups/v3.1.1/clinical_notes_guidance_group'
require 'us_core_test_kit/custom_groups/data_absent_reason_group'
require 'us_core_test_kit/provenance_validator'
require 'us_core_test_kit/us_core_options'

require 'us_core_test_kit/generated/v3.1.1/patient_group'
require 'us_core_test_kit/generated/v3.1.1/allergy_intolerance_group'
require 'us_core_test_kit/generated/v3.1.1/care_plan_group'
require 'us_core_test_kit/generated/v3.1.1/care_team_group'
require 'us_core_test_kit/generated/v3.1.1/condition_group'
require 'us_core_test_kit/generated/v3.1.1/device_group'
require 'us_core_test_kit/generated/v3.1.1/diagnostic_report_note_group'
require 'us_core_test_kit/generated/v3.1.1/diagnostic_report_lab_group'
require 'us_core_test_kit/generated/v3.1.1/document_reference_group'
require 'us_core_test_kit/generated/v3.1.1/goal_group'
require 'us_core_test_kit/generated/v3.1.1/immunization_group'
require 'us_core_test_kit/generated/v3.1.1/medication_request_group'
require 'us_core_test_kit/generated/v3.1.1/smokingstatus_group'
require 'us_core_test_kit/generated/v3.1.1/pediatric_weight_for_height_group'
require 'us_core_test_kit/generated/v3.1.1/observation_lab_group'
require 'us_core_test_kit/generated/v3.1.1/pediatric_bmi_for_age_group'
require 'us_core_test_kit/generated/v3.1.1/pulse_oximetry_group'
require 'us_core_test_kit/generated/v3.1.1/head_circumference_group'
require 'us_core_test_kit/generated/v3.1.1/bodyheight_group'
require 'us_core_test_kit/generated/v3.1.1/bodytemp_group'
require 'us_core_test_kit/generated/v3.1.1/bp_group'
require 'us_core_test_kit/generated/v3.1.1/bodyweight_group'
require 'us_core_test_kit/generated/v3.1.1/heartrate_group'
require 'us_core_test_kit/generated/v3.1.1/resprate_group'
require 'us_core_test_kit/generated/v3.1.1/procedure_group'
require 'us_core_test_kit/generated/v3.1.1/encounter_group'
require 'us_core_test_kit/generated/v3.1.1/organization_group'
require 'us_core_test_kit/generated/v3.1.1/practitioner_group'
require 'us_core_test_kit/generated/v3.1.1/provenance_group'

module CancerPathologyDataSharingTestKit
  class USCoreDataAccessGroup < Inferno::TestGroup
    id :cpds_us_core_data_access
    title 'US Core FHIR API Tests'
    short_description 'Verify that cancer patient data are available via US Core API.'
    description %(
        Tests verify that the EHR/LIS allows clients to access patient data via the [US Core API](http://hl7.org/fhir/us/core/STU3.1.1/index.html). 

        
    )
      input :url,
        title: 'FHIR Endpoint',
        description: 'URL of the FHIR endpoint' 
        
      input :smart_credentials,
        title: 'OAuth Credentials',
        type: :oauth_credentials,
        optional: false

      fhir_client do
        url :url
        oauth_credentials :smart_credentials
      end

      group from: :us_core_v311_capability_statement
      group from: :us_core_v311_patient
      group from: :us_core_v311_allergy_intolerance
      group from: :us_core_v311_care_plan
      group from: :us_core_v311_care_team
      group from: :us_core_v311_condition
      group from: :us_core_v311_device
      group from: :us_core_v311_diagnostic_report_note
      group from: :us_core_v311_diagnostic_report_lab
      group from: :us_core_v311_document_reference
      group from: :us_core_v311_goal
      group from: :us_core_v311_immunization
      group from: :us_core_v311_medication_request
      group from: :us_core_v311_smokingstatus
      group from: :us_core_v311_pediatric_weight_for_height
      group from: :us_core_v311_observation_lab
      group from: :us_core_v311_pediatric_bmi_for_age
      group from: :us_core_v311_pulse_oximetry
      group from: :us_core_v311_head_circumference
      group from: :us_core_v311_bodyheight
      group from: :us_core_v311_bodytemp
      group from: :us_core_v311_bp
      group from: :us_core_v311_bodyweight
      group from: :us_core_v311_heartrate
      group from: :us_core_v311_resprate
      group from: :us_core_v311_procedure
      group from: :us_core_v311_encounter
      group from: :us_core_v311_organization
      group from: :us_core_v311_practitioner
      group from: :us_core_v311_provenance
      group from: :us_core_v311_clinical_notes_guidance
      group from: :us_core_311_data_absent_reason
  end
end