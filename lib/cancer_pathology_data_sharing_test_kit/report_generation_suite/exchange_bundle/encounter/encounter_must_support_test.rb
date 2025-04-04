require_relative '../../../must_support_test'
require_relative '../../../group_metadata'

module CancerPathologyDataSharingTestKit
  module V101
    class EncounterMustSupportTest < Inferno::Test
      include CancerPathologyDataSharingTestKit::MustSupportTest

      title 'All must support elements are provided in the US Core Encounter resources'
      description %(
        Report generators SHALL be capable of populating all must support data elements
        defined in the [US Pathology ExchangeBundle profile](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/StructureDefinition-us-pathology-exchange-bundle.html)
        and profiles it references. This test will look through the Encounter resources
        found in the provided report Bundles for the following must support elements:

        * Encounter.class
        * Encounter.hospitalization
        * Encounter.hospitalization.dischargeDisposition
        * Encounter.identifier
        * Encounter.identifier.system
        * Encounter.identifier.value
        * Encounter.location
        * Encounter.location.location
        * Encounter.participant
        * Encounter.participant.individual
        * Encounter.participant.period
        * Encounter.participant.type
        * Encounter.period
        * Encounter.reasonCode
        * Encounter.status
        * Encounter.subject
        * Encounter.type
      )

      id :cpds_v101_us_core_v311_encounter_must_support_test

      def resource_type
        'Encounter'
      end

      def self.metadata
        @metadata ||= GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      run do
        all_resources = scratch[:cpds_resources]&.values&.map do |bundle_resources|
          bundle_resources['Encounter'] || []
        end
        perform_must_support_test(all_resources&.flatten)
      end
    end
  end
end
