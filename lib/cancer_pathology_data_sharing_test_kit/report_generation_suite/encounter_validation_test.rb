require_relative '../bundle_parse'
require_relative '../validation_test'

module CancerPathologyDataSharingTestKit
  class EncounterValidationTest < Inferno::Test
    include CancerPathologyDataSharingTestKit::ValidationTest
    include CancerPathologyDataSharingTestKit::BundleParse

    title 'Encounter resources confirm to the US Core Encounter profile'
    description %()

    id :encounter_validation_test

    def resource_type
      'Encounter'
    end

    run do
      scratch[:cpds].each do |bundle_resources|
        resources = bundle_resources['Encounter']

        # Go ahead and skip if resources is all empty
        skip_if resources.blank?, "No #{resource_type} resources were returned."

        profile_url = PE_BUNDLE_SLICE_RESOURCES['Encounter']
        perform_validation_test('Encounter', resources, profile_url, '5.0.1')
      end
    end
  end
end