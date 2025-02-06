require_relative '../bundle_parse'
require_relative '../validation_test'

module CancerPathologyDataSharingTestKit
  class ServiceRequestValidationTest < Inferno::Test
    include CancerPathologyDataSharingTestKit::ValidationTest
    include CancerPathologyDataSharingTestKit::BundleParse

    title 'ServiceRequest resources confirm to the US Pathology ServiceRequest profile'
    description %()

    id :service_request_validation_test

    def resource_type
      'ServiceRequest'
    end

    run do
      scratch[:cpds].each do |bundle_resources|
        resources = bundle_resources['ServiceRequest']

        # Go ahead and skip if resources is all empty
        skip_if resources.blank?, "No #{resource_type} resources were returned."

        profile_url = PE_BUNDLE_SLICE_RESOURCES['ServiceRequest']
        perform_validation_test('ServiceRequest', resources, profile_url, '1.0.1')
      end
    end
  end
end