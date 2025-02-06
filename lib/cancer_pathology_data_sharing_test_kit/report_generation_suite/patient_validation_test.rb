require_relative '../bundle_parse'
require_relative '../validation_test'

module CancerPathologyDataSharingTestKit
  class PatientValidationTest < Inferno::Test
    include CancerPathologyDataSharingTestKit::ValidationTest
    include CancerPathologyDataSharingTestKit::BundleParse

    title 'Patient resources confirm to the US Core Patient profile'
    description %()

    id :patient_validation_test

    def resource_type
      'Patient'
    end

    run do
      scratch[:cpds].each do |bundle_resources|
        resources = bundle_resources['Patient']

        # Go ahead and skip if resources is all empty
        skip_if resources.blank?, "No #{resource_type} resources were returned."

        profile_url = PE_BUNDLE_SLICE_RESOURCES['Patient']
        perform_validation_test('Patient', resources, profile_url, '5.0.1')
      end
    end
  end
end