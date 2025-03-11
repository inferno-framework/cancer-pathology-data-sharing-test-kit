require_relative '../../../must_support_test'
require_relative '../../../generator/group_metadata'

module CancerPathologyDataSharingTestKit
  module V101
    class ServiceRequestMustSupportTest < Inferno::Test
      include CancerPathologyDataSharingTestKit::MustSupportTest

      title 'All must support elements are provided in the Service Request resources'
      description %(
        SHC Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the SHC Server Capability
        Statement. This test will look through the ServiceRequest resources
        found previously for the following must support elements:

        * ServiceRequest.ServiceRequest
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

      id :v101_service_request_must_support_test

      def resource_type
        'ServiceRequest'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
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
