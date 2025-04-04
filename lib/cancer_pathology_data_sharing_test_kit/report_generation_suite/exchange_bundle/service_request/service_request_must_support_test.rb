require_relative '../../../must_support_test'
require_relative '../../../group_metadata'

module CancerPathologyDataSharingTestKit
  module V101
    class ServiceRequestMustSupportTest < Inferno::Test
      include CancerPathologyDataSharingTestKit::MustSupportTest

      title 'All must support elements are provided in the Service Request resources'
      description %(
        Report generators SHALL be capable of populating all must support data elements
        defined in the [US Pathology ExchangeBundle profile](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/StructureDefinition-us-pathology-exchange-bundle.html)
        and profiles it references. This test will look through the ServiceRequest resources
        found in the provided report Bundles for the following must support elements:

        * ServiceRequest.authoredOn
        * ServiceRequest.basedOn
        * ServiceRequest.category
        * ServiceRequest.category:us-core
        * ServiceRequest.code
        * ServiceRequest.encounter
        * ServiceRequest.identifier
        * ServiceRequest.intent
        * ServiceRequest.occurrencePeriod
        * ServiceRequest.requester
        * ServiceRequest.status
        * ServiceRequest.subject
      )

      id :cpds_v101_service_request_must_support_test

      def resource_type
        'ServiceRequest'
      end

      def self.metadata
        @metadata ||= GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:service_request_resources] ||= {}
      end

      run do
        all_resources = scratch[:cpds_resources]&.values&.map do |bundle_resources|
          bundle_resources['ServiceRequest'] || []
        end
        perform_must_support_test(all_resources&.flatten)
      end
    end
  end
end
