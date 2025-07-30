require_relative 'exchange_bundle/us_pathology_exchange_bundle/exchange_bundle_validation_test'
require_relative 'exchange_bundle/us_pathology_diagnostic_report/diagnostic_report_validation_test'
require_relative 'exchange_bundle/encounter/encounter_validation_test'
require_relative 'exchange_bundle/practitioner_role/practitioner_role_validation_test'
require_relative 'exchange_bundle/patient/patient_validation_test'
require_relative 'exchange_bundle/service_request/service_request_validation_test'
require_relative 'exchange_bundle/specimen/specimen_validation_test'

require_relative 'exchange_bundle/us_pathology_exchange_bundle/us_pathology_exchange_bundle_must_support_test'
require_relative 'exchange_bundle/patient/patient_must_support_test'
require_relative 'exchange_bundle/encounter/encounter_must_support_test'
require_relative 'exchange_bundle/us_pathology_diagnostic_report/us_pathology_diagnostic_report_must_support_test'
require_relative 'exchange_bundle/specimen/specimen_must_support_test'
require_relative 'exchange_bundle/service_request/service_request_must_support_test'
require_relative 'exchange_bundle/practitioner_role/practitioner_role_must_support_test'

require_relative 'data_absent_group'

module CancerPathologyDataSharingTestKit
  class ExchangeBundleGroup < Inferno::TestGroup
    title 'Exchange Bundle Group'
    id :cpds_exchange_bundle_group
    description %(
      # Background

      These tests verify that the system under test can generate conformant and complete cancer pathology reports
      according to the [Cancer Pathology Data Sharing Implementation Guide](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/).
      The tests focus on validating the [Cancer Pathology Exchange Bundle profile](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/StructureDefinition-us-pathology-exchange-bundle.html)
      and all its required components.

      # Testing Methodology

      ## Report Submission
      The tester provides one or more cancer pathology report bundles through the **Cancer Reports** input.
      Each bundle should represent a complete pathology report ready for submission to a cancer registry.

      ## Bundle Structure Validation
      Each bundle is validated to ensure:
      * Type is set to "transaction"
      * Timestamp is present indicating when the bundle was created
      * All required entries are present with correct cardinality
      * Resources conform to their required profiles
      * References between resources are valid and resolvable

      ## Required Resources
      Each cancer pathology report bundle must contain:
      * Patient Demographics (1..1)
        * Must conform to [US Core Patient](http://hl7.org/fhir/us/core/STU5.0.1/StructureDefinition-us-core-patient.html)
        * Contains essential patient identification and demographic data
      * Encounter Information (1..1)
        * Must conform to [US Core Encounter](http://hl7.org/fhir/us/core/STU5.0.1/StructureDefinition-us-core-encounter.html)
        * Documents the context of the pathology examination
      * Diagnostic Report (1..1)
        * Must conform to [US Pathology Diagnostic Report](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/StructureDefinition-us-pathology-diagnostic-report.html)
        * Contains the core pathology findings and interpretations
      * Specimen Details (1..*)
        * Must conform to [US Pathology Specimen](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/StructureDefinition-us-pathology-specimen.html)
        * Describes the specimens examined
      * Service Request (1..1)
        * Must conform to [Cancer Pathology Service Request](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/StructureDefinition-us-pathology-service-request.html)
        * Documents the original order/request
      * Organization Information (1..*)
        * Must conform to [US Core Organization](http://hl7.org/fhir/us/core/STU5.0.1/StructureDefinition-us-core-organization.html)
        * Identifies the facilities involved
      * Provider Information
        * Practitioners (1..*)
          * Must conform to [US Core Practitioner](http://hl7.org/fhir/us/core/STU5.0.1/StructureDefinition-us-core-practitioner.html)
        * PractitionerRoles (1..*)
          * Must conform to [US Core PractitionerRole](http://hl7.org/fhir/us/core/STU5.0.1/StructureDefinition-us-core-practitionerrole.html)
        * Identifies the healthcare providers involved and their roles

      ## Profile Validation
      For each resource type, the tests verify:
      * Conformance to the required profile
      * Presence of all required elements
      * Correct use of required terminologies and value sets
      * Valid references to other resources
      * Proper cardinality of elements and slices

      ## Must Support Validation
      For each profile, the tests verify that all elements marked as "must support" are demonstrated
      at least once across the submitted reports. This ensures systems can:
      * Populate all required data elements
      * Handle all required data types and structures
      * Support all required workflows and use cases

      ## Missing Data Handling
      The tests also verify proper implementation of missing data patterns:
      * Use of DataAbsentReason Extension for non-coded required fields
      * Use of appropriate "unknown" codes for coded fields
      * Proper handling of optional missing elements
    )
    run_as_group

    group do
      title 'Report'
      test from: :cpds_exchange_bundle_validation_test
      test from: :cpds_v101_us_pathology_exchange_bundle_must_support_test
    end

    group do
      title 'Patient'
      test from: :cpds_patient_validation_test
      test from: :cpds_v101_us_core_v311_patient_must_support_test
    end

    group do
      title 'Encounter'
      test from: :cpds_encounter_validation_test
      test from: :cpds_v101_us_core_v311_encounter_must_support_test
    end

    group do
      title 'Diagnostic Report'
      test from: :cpds_diagnostic_report_validation_test
      test from: :cpds_v101_us_pathology_diagnostic_report_must_support_test
    end

    group do
      title 'Specimen'
      test from: :cpds_specimen_validation_test
      test from: :cpds_v101_specimen_must_support_test
    end

    group do
      title 'Service Request'
      test from: :cpds_service_request_validation_test
      test from: :cpds_v101_service_request_must_support_test
    end

    group do
      title 'Practitioner Role'
      test from: :cpds_practitioner_role_validation_test
      test from: :cpds_v101_practitioner_role_must_support_test
    end
    group from: :cpds_data_absent_reason
  end
end
