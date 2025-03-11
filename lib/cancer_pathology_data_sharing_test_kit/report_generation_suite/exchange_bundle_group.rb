require_relative 'exchange_bundle/exchange_bundle_validation_test'
require_relative 'exchange_bundle/diagnostic_report_validation_test'
require_relative 'exchange_bundle/encounter_validation_test'
require_relative 'exchange_bundle/practitioner_role_validation_test'
require_relative 'exchange_bundle/patient_validation_test'
require_relative 'exchange_bundle/service_request_validation_test'
require_relative 'exchange_bundle/specimen_validation_test'

require_relative '../generated/v1.0.1/us_pathology_exchange_bundle/us_pathology_exchange_bundle_must_support_test'
require_relative '../generated/v1.0.1/patient/patient_must_support_test'
require_relative '../generated/v1.0.1/encounter/encounter_must_support_test'
require_relative '../generated/v1.0.1/us_pathology_diagnostic_report/us_pathology_diagnostic_report_must_support_test'
require_relative '../generated/v1.0.1/specimen/specimen_must_support_test'
require_relative '../generated/v1.0.1/service_request/service_request_must_support_test'
require_relative '../generated/v1.0.1/practitioner_role/practitioner_role_must_support_test'

module CancerPathologyDataSharingTestKit
  class ExchangeBundleGroup < Inferno::TestGroup
    title 'Exchange Bundle Group'
    id :exchange_bundle_group
    description %()
    run_as_group
    
    test from: :exchange_bundle_validation_test
    test from: :v101_us_pathology_exchange_bundle_must_support_test
    test from: :patient_validation_test
    test from: :v101_us_core_v311_patient_must_support_test
    test from: :encounter_validation_test
    test from: :v101_us_core_v311_encounter_must_support_test
    test from: :diagnostic_report_validation_test
    test from: :v101_us_pathology_diagnostic_report_must_support_test
    test from: :specimen_validation_test
    test from: :v101_specimen_must_support_test
    test from: :service_request_validation_test
    test from: :v101_service_request_must_support_test
    test from: :practitioner_role_validation_test
    test from: :v101_practitioner_role_must_support_test

  end
end