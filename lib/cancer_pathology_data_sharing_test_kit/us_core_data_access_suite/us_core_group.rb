require 'us_core_test_kit'

module CancerPathologyDataSharingTestKit
  class USCoreDataAccessGroup < Inferno::TestGroup
    id :cpds_us_core_data_access
    title 'US Core FHIR API Tests'
    short_description 'Verify that cancer patient data are available via US Core API.'
    description %(
      During these tests, Inferno will simulate a FHIR client and verify that it can use the target systems's
      FHIR APIs to access [US Core v5](http://hl7.org/fhir/us/core/STU3.1.1/index.html) data.
    )
    input :url,
          title: 'FHIR Endpoint',
          description: 'URL of the FHIR endpoint'

    input :smart_credentials,
          title: 'OAuth Credentials',
          type: :auth_info,
          optional: true

    fhir_client do
      url :url
      auth_info :smart_credentials
    end

    group from: :us_core_v501_capability_statement

    group from: :us_core_v501_patient
    group from: :us_core_v501_allergy_intolerance
    group from: :us_core_v501_care_plan
    group from: :us_core_v501_care_team
    group from: :us_core_v501_condition_encounter_diagnosis
    group from: :us_core_v501_condition_problems_health_concerns
    group from: :us_core_v501_device
    group from: :us_core_v501_diagnostic_report_note
    group from: :us_core_v501_diagnostic_report_lab
    group from: :us_core_v501_document_reference
    group from: :us_core_v501_encounter
    group from: :us_core_v501_goal
    group from: :us_core_v501_immunization
    group from: :us_core_v501_medication_request
    group from: :us_core_v501_observation_lab
    group from: :us_core_v501_observation_sdoh_assessment
    group from: :us_core_v501_respiratory_rate
    group from: :us_core_v501_observation_social_history
    group from: :us_core_v501_heart_rate
    group from: :us_core_v501_body_temperature
    group from: :us_core_v501_pediatric_weight_for_height
    group from: :us_core_v501_pulse_oximetry
    group from: :us_core_v501_smokingstatus
    group from: :us_core_v501_observation_sexual_orientation
    group from: :us_core_v501_head_circumference
    group from: :us_core_v501_body_height
    group from: :us_core_v501_bmi
    group from: :us_core_v501_blood_pressure
    group from: :us_core_v501_observation_imaging
    group from: :us_core_v501_observation_clinical_test
    group from: :us_core_v501_pediatric_bmi_for_age
    group from: :us_core_v501_head_circumference_percentile
    group from: :us_core_v501_body_weight
    group from: :us_core_v501_procedure
    group from: :us_core_v501_questionnaire_response
    group from: :us_core_v501_service_request
    group from: :us_core_v501_organization
    group from: :us_core_v501_practitioner
    group from: :us_core_v501_practitioner_role
    group from: :us_core_v501_provenance
    group from: :us_core_v501_related_person
    group from: :us_core_v400_clinical_notes_guidance
    group from: :us_core_311_data_absent_reason
  end
end
