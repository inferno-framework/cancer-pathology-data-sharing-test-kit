require_relative '../../../must_support_test'
require_relative '../../../group_metadata'

module CancerPathologyDataSharingTestKit
  module V101
    class PractitionerRoleMustSupportTest < Inferno::Test
      include CancerPathologyDataSharingTestKit::MustSupportTest

      title 'All must support elements are provided in the Practitioner Role resources'
      description %(
        Report generators SHALL be capable of populating all must support data elements
        defined in the [US Pathology ExchangeBundle profile](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/StructureDefinition-us-pathology-exchange-bundle.html)
        and profiles it references. This test will look through the PractitionerRole resources
        found in the provided report Bundles for the following must support elements:

        * PractitionerRole.code
        * PractitionerRole.endpoint
        * PractitionerRole.location
        * PractitionerRole.organization
        * PractitionerRole.practitioner
        * PractitionerRole.specialty
        * PractitionerRole.telecom
        * PractitionerRole.telecom.system
        * PractitionerRole.telecom.value
      )

      id :cpds_v101_practitioner_role_must_support_test

      def resource_type
        'PractitionerRole'
      end

      def self.metadata
        @metadata ||= GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      run do
        all_resources = scratch[:cpds_resources]&.values&.map do |bundle_resources|
          bundle_resources['PractitionerRole'] || []
        end
        perform_must_support_test(all_resources&.flatten)
      end
    end
  end
end
