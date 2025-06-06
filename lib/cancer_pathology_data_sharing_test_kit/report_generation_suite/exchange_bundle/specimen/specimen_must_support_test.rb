require_relative '../../../must_support_test'
require_relative '../../../group_metadata'

module CancerPathologyDataSharingTestKit
  module V101
    class SpecimenMustSupportTest < Inferno::Test
      include CancerPathologyDataSharingTestKit::MustSupportTest

      title 'All must support elements are provided in the Specimen resources'
      description %(
        Report generators SHALL be capable of populating all must support data elements
        defined in the [US Pathology ExchangeBundle profile](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/StructureDefinition-us-pathology-exchange-bundle.html)
        and profiles it references. This test will look through the Specimen resources
        found in the provided report Bundles for the following must support elements:

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

      id :cpds_v101_specimen_must_support_test

      def resource_type
        'Specimen'
      end

      def self.metadata
        @metadata ||= GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
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
