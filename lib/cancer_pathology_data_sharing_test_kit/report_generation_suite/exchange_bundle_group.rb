require_relative 'exchange_bundle/content_bundle_must_support_test'
require_relative 'exchange_bundle/content_bundle_validation_test'
require_relative 'exchange_bundle/diagnostic_report_validation_test'
require_relative 'exchange_bundle/encounter_validation_test'
require_relative 'exchange_bundle/practitioner_role_validation_test'
require_relative 'exchange_bundle/patient_validation_test'
require_relative 'exchange_bundle/service_request_validation_test'
require_relative 'exchange_bundle/specimen_validation_test'

module CancerPathologyDataSharingTestKit
  class MustSupportGroup < Inferno::TestGroup
    title 'Content Exchange Bundle Group'
    id :exchange_bundle_group
    description %()

    run_as_group
    
    test from: :content_bundle_validation_test
    test from: :content_bundle_must_support_test
    test from: :patient_validation_test
    test from: :encounter_validation_test
    test from: :diagnostic_report_validation_test
    test from: :specimen_validation_test
    test from: :service_request_validation_test
    test from: :practitioner_role_validation_test

  end
end