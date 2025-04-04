require_relative 'us_core_data_access_suite/us_core_group'
module CancerPathologyDataSharingTestKit
  class USCoreDataAccessSuite < Inferno::TestSuite
    id :cpds_data_access
    title 'Cancer Pathology Data Sharing Data Access Test Suite'
    short_title 'CPDS Data Access Suite'
    description File.read(File.join(__dir__, 'docs', 'data_access_suite_description.md'))
    links [
      {
        label: 'Report Issue',
        url: 'https://github.com/inferno-framework/cancer-pathology-data-sharing-test-kit/issues/'
      },
      {
        label: 'Open Source',
        url: 'https://github.com/inferno-framework/cancer-pathology-data-sharing-test-kit/'
      },
      {
        label: 'Download',
        url: 'https://github.com/inferno-framework/cancer-pathology-data-sharing-test-kit/releases'
      },
      {
        label: 'Implementation Guide',
        url: 'https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/'
      }
    ]

    GENERAL_MESSAGE_FILTERS = [
      %r{Sub-extension url 'introspect' is not defined by the Extension http://fhir-registry\.smarthealthit\.org/StructureDefinition/oauth-uris},
      %r{Sub-extension url 'revoke' is not defined by the Extension http://fhir-registry\.smarthealthit\.org/StructureDefinition/oauth-uris},
      /Observation\.effective\.ofType\(Period\): .*vs-1:/, # Invalid invariant in FHIR v4.0.1
      /Observation\.effective\.ofType\(Period\): .*us-core-1:/, # Invalid invariant in US Core v3.1.1
      /Provenance.agent\[\d*\]: Constraint failed: provenance-1/, # Invalid invariant in US Core v5.0.1
      %r{Unknown Code System 'http://hl7.org/fhir/us/core/CodeSystem/us-core-tags'}, # Validator has an issue with this US Core 5 code system in US Core 6 resource # rubocop:disable Layout/LineLength
      %r{URL value 'http://hl7.org/fhir/us/core/CodeSystem/us-core-tags' does not resolve}, # Validator has an issue with this US Core 5 code system in US Core 6 resource # rubocop:disable Layout/LineLength
      /\A\S+: \S+: URL value '.*' does not resolve/,
      %r{Observation.component\[\d+\].value.ofType\(Quantity\): The code provided \(http://unitsofmeasure.org#L/min\) was not found in the value set 'Vital Signs Units'} # Known issue with the Pulse Oximetry Profile # rubocop:disable Layout/LineLength
    ].freeze

    VERSION_SPECIFIC_MESSAGE_FILTERS = [].freeze

    VALIDATION_MESSAGE_FILTERS = GENERAL_MESSAGE_FILTERS + VERSION_SPECIFIC_MESSAGE_FILTERS

    fhir_resource_validator do
      igs('hl7.fhir.us.core#5.0.1')
      message_filters = VALIDATION_MESSAGE_FILTERS

      exclude_message do |message|
        message_filters.any? { |filter| filter.match? message.message }
      end

      perform_additional_validation do |resource, _profile_url|
        USCoreTestKit::ProvenanceValidator.validate(resource) if resource.instance_of?(FHIR::Provenance)
      end
    end

    group from: :cpds_us_core_data_access
  end
end
