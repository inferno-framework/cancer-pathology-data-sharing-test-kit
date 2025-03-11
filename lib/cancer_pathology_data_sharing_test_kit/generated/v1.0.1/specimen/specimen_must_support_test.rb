require_relative '../../../must_support_test'
require_relative '../../../generator/group_metadata'

module CancerPathologyDataSharingTestKit
  module V101
    class SpecimenMustSupportTest < Inferno::Test
      include CancerPathologyDataSharingTestKit::MustSupportTest

      title 'All must support elements are provided in the Specimen resources'
      description %(
        SHC Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the SHC Server Capability
        Statement. This test will look through the Specimen resources
        found previously for the following must support elements:

        * Specimen.accessionIdentifier
        * Specimen.collection
        * Specimen.collection.bodySite
        * Specimen.collection.collected[x]
        * Specimen.collection.collector
        * Specimen.collection.method
        * Specimen.container
        * Specimen.identifier
        * Specimen.note
        * Specimen.parent
        * Specimen.receivedTime
        * Specimen.status
        * Specimen.type
      )

      id :v101_specimen_must_support_test

      def resource_type
        'Specimen'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:specimen_resources] ||= {}
      end

      run do
        all_resources = scratch[:cpds_resources]&.values&.map do |bundle_resources|
          bundle_resources['Specimen'] || []
        end
        perform_must_support_test(all_resources&.flatten)
      end
    end
  end
end
