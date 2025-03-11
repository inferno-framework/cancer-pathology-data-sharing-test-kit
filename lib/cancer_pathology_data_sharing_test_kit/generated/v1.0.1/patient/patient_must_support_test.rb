require_relative '../../../must_support_test'
require_relative '../../../generator/group_metadata'

module CancerPathologyDataSharingTestKit
  module V101
    class PatientMustSupportTest < Inferno::Test
      include CancerPathologyDataSharingTestKit::MustSupportTest

      title 'All must support elements are provided in the US Core Patient resources'
      description %(
        SHC Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the SHC Server Capability
        Statement. This test will look through the Patient resources
        found previously for the following must support elements:

        * Patient.address
        * Patient.address.city
        * Patient.address.line
        * Patient.address.postalCode
        * Patient.address.state
        * Patient.birthDate
        * Patient.communication
        * Patient.communication.language
        * Patient.extension:birthsex
        * Patient.extension:ethnicity
        * Patient.extension:race
        * Patient.gender
        * Patient.identifier
        * Patient.identifier.system
        * Patient.identifier.value
        * Patient.name
        * Patient.name.family
        * Patient.name.given
        * Patient.telecom
        * Patient.telecom.system
        * Patient.telecom.use
        * Patient.telecom.value
      )

      id :v101_us_core_v311_patient_must_support_test

      def resource_type
        'Patient'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      run do
        all_resources = scratch[:cpds_resources]&.values&.map do |bundle_resources|
          bundle_resources['Patient'] || []
        end
        perform_must_support_test(all_resources&.flatten)
      end
    end
  end
end
