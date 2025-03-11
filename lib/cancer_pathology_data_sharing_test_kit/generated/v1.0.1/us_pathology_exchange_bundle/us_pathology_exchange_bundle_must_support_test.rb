require_relative '../../../must_support_test'
require_relative '../../../generator/group_metadata'

module CancerPathologyDataSharingTestKit
  module V101
    class UsPathologyExchangeBundleMustSupportTest < Inferno::Test
      include CancerPathologyDataSharingTestKit::MustSupportTest

      title 'All must support elements are provided in the US Pathology Exchange Bundle resources'
      description %(
        SHC Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the SHC Server Capability
        Statement. This test will look through the Bundle resources
        found previously for the following must support elements:

        * Bundle.entry
        * Bundle.entry:pathology-related-practitioner.resource
        * Bundle.entry:service-request.resource
        * Bundle.entry:us_core_encounter.resource
        * Bundle.entry:us_core_patient.resource
        * Bundle.timestamp
        * Bundle.type
      )

      id :v101_us_pathology_exchange_bundle_must_support_test

      def resource_type
        'Bundle'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      run do
        all_resources = scratch[:cpds_exchange_bundles]
        perform_must_support_test(all_resources&.flatten)
      end
    end
  end
end
