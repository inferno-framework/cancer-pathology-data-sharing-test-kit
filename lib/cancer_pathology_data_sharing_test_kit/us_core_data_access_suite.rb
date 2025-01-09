require_relative 'us_core_data_access_suite/us_core_group'
module CancerPathologyDataSharingTestKit
  class USCoreDataAccessSuite < Inferno::TestSuite
    id :cpds_data_access
    title 'Cancer Pathology Data Sharing Data Access Test Suite'
    short_title 'CPDS Data Access Suite'
    description '
    Test Suite verifies the ability of clinical systems to make [US Core](http://hl7.org/fhir/us/core/STU5.0.1/) data accessible to other systems. Both
    [LIS](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/CapabilityStatement-pathology-lab-information-system.html)
     and [EHR](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/CapabilityStatement-central-cancer-registry-reporting-ehr-pathology.html) 
     capability statements specify support of as part of the STU 1.0.1 version of the HL7® FHIR® 
    [Cancer Pathology Data Sharing IG](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/).
    
    ## Scope
    
    Determine if clinical systems (LIS & EHR) make data available via US Core API. Testing ability to request data
     or exchange of service requests and diagnostic reports is out of scope.

    ## Test Methodology
    
    Inferno, acting as a client, requests information from a clinical system under test (EHR or LIS), verifying
    that returned information is complete and conformant to US Core profiles.
    
    ## Current Limitations
    
    These tests do not cover the full capability statements for LIS and EHR systems as a part of the CPDS IG. Support of 
    service requests and diagnostic reports exchanged between LIS and EHR systems before 
    pathology data is transmitted to central registries is not tested. Transmission of reports is also not tested.
    '

    links [
      # {
      #   label: 'Report Issue',
      #   url: 'https://github.com/inferno-framework/cancer-registry-reporting-test-kit/issues'
      # },
      # {
      #   label: 'Open Source',
      #   url: 'https://github.com/inferno-framework/cancer-registry-reporting-test-kit'
      # },
      # {
      #   label: 'Download',
      #   url: 'https://github.com/inferno-framework/cancer-registry-reporting-test-kit/releases'
      # },
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
      /Provenance.agent\[\d*\]: Constraint failed: provenance-1/, #Invalid invariant in US Core v5.0.1
      %r{Unknown Code System 'http://hl7.org/fhir/us/core/CodeSystem/us-core-tags'}, # Validator has an issue with this US Core 5 code system in US Core 6 resource
      %r{URL value 'http://hl7.org/fhir/us/core/CodeSystem/us-core-tags' does not resolve}, # Validator has an issue with this US Core 5 code system in US Core 6 resource
      /\A\S+: \S+: URL value '.*' does not resolve/,
      %r{Observation.component\[\d+\].value.ofType\(Quantity\): The code provided \(http://unitsofmeasure.org#L/min\) was not found in the value set 'Vital Signs Units'} # Known issue with the Pulse Oximetry Profile
    ].freeze

    VERSION_SPECIFIC_MESSAGE_FILTERS = [].freeze

    VALIDATION_MESSAGE_FILTERS = GENERAL_MESSAGE_FILTERS + VERSION_SPECIFIC_MESSAGE_FILTERS

    def self.metadata
      @metadata ||= YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true)[:groups].map do |raw_metadata|
          Generator::GroupMetadata.new(raw_metadata)
        end
    end

    fhir_resource_validator do
      igs('hl7.fhir.us.core#5.0.1')
      message_filters = VALIDATION_MESSAGE_FILTERS

      exclude_message do |message|

        message_filters.any? { |filter| filter.match? message.message }
      end

      perform_additional_validation do |resource, profile_url|
        USCoreTestKit::ProvenanceValidator.validate(resource) if resource.instance_of?(FHIR::Provenance)
      end
    end

    group from: :cpds_us_core_data_access

  end
end