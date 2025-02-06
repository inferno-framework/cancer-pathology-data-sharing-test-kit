require_relative '../../must_support_test'
require_relative '../../generator/group_metadata'


module CancerPathologyDataSharingTestKit
    class UsPathologyExchangeBundleMustSupportTest < Inferno::Test
      include CancerPathologyDataSharingTestKit::MustSupportTest

      title 'All must support elements are provided in the Cancer Pathology Exchange Bundle resources returned'
      description %(
        This test will look through the Cancer Pathology Exchange Bundle resources
        found previously for the following must support elements:

        * Bundle.entry
        * Bundle.entry:pathology-related-practitioner.resource
        * Bundle.entry:service-request.resource
        * Bundle.entry:us_core_encounter.resource
        * Bundle.entry:us_core_patient.resource
        * Bundle.timestamp
        * Bundle.type
      )

      id :content_bundle_must_support_test

      def resource_type
        'Bundle'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:cpds_exchange_bundle_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
end
