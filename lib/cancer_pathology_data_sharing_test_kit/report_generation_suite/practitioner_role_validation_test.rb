require_relative '../bundle_parse'
require_relative '../validation_test'

module CancerPathologyDataSharingTestKit
  class PractitionerRoleValidationTest < Inferno::Test
    include CancerPathologyDataSharingTestKit::ValidationTest
    include CancerPathologyDataSharingTestKit::BundleParse

    title 'PractitionerRole resources confirm to the US Pathology PractitionerRole profile'
    description %()

    id :practitioner_role_validation_test

    def resource_type
      'PractitionerRole'
    end

    run do
      scratch[:cpds].each do |bundle_resources|
        resources = bundle_resources['PractitionerRole']

        # Go ahead and skip if resources is all empty
        skip_if resources.blank?, "No #{resource_type} resources were returned."

        profile_url = PE_BUNDLE_SLICE_RESOURCES['PractitionerRole']
        perform_validation_test('PractitionerRole', resources, profile_url, '1.0.1')
      end
    end
  end
end