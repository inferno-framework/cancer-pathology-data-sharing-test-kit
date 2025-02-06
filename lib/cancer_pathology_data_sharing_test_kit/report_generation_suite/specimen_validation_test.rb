require_relative '../bundle_parse'
require_relative '../validation_test'

module CancerPathologyDataSharingTestKit
  class SpecimenValidationTest < Inferno::Test
    include CancerPathologyDataSharingTestKit::ValidationTest
    include CancerPathologyDataSharingTestKit::BundleParse

    title 'Specimen resources confirm to the US Pathology Specimen profile'
    description %()

    id :specimen_validation_test

    def resource_type
      'Specimen'
    end

    run do
      scratch[:cpds].each do |bundle_resources|
        resources = bundle_resources['Specimen']

        # Go ahead and skip if resources is all empty
        skip_if resources.blank?, "No #{resource_type} resources were returned."

        profile_url = PE_BUNDLE_SLICE_RESOURCES['Specimen']
        perform_validation_test('Specimen', resources, profile_url, '1.0.1')
      end
    end
  end
end