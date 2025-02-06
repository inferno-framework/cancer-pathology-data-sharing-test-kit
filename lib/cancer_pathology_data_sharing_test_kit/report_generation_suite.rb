require 'inferno/dsl/oauth_credentials'

require_relative 'report_generation_suite/cpds_bundle_generation_test'
require_relative 'version'
require_relative 'report_generation_suite/exchange_bundle_group'

module CancerPathologyDataSharingTestKit
  class ReportGenerationSuite < Inferno::TestSuite
    title 'Cancer Pathology Data Sharing Report Generation Test Suite'
    short_title 'CPDS Report Generation Test Suite'
    description %(
    Test Suite verifies the ability of clinical systems to generate a cancer pathology report in the form of
    [Pathology Cancer Registry Content Bundle(s)](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/StructureDefinition-us-pathology-content-bundle.html). 
    The tests verify that included content is complete and conformant as specified in the STU 1.0.1 version of the HL7® FHIR® 
    [Cancer Pathology Data Sharing IG](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/).

    ## Scope
    
    Determine if clinical systems (LIS & EHR) are able to generate valid cancer pathology bundles. 
    Testing ability to transmit these bundles to registries out of scope. Must support elements are only
    verified for the bundle itself.

    ## Test Methodology
    
    Inferno, given a set of content bundles, will parse the bundles, extracting individual resources. All references
  in the bundle should resolve, leading to profile conformant resources.
    
    
    )
    version VERSION

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
    VALIDATION_MESSAGE_FILTERS = GENERAL_MESSAGE_FILTERS

    def self.metadata
      @metadata ||= YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true)[:groups].map do |raw_metadata|
          Generator::GroupMetadata.new(raw_metadata)
        end
    end

    id :cpds_report_generation

    fhir_resource_validator do
      igs 'hl7.fhir.us.cancer-reporting#1.0.1', 'hl7.fhir.us.core#5.0.1'
      message_filters = VALIDATION_MESSAGE_FILTERS

      exclude_message do |message|

        message_filters.any? { |filter| filter.match? message.message }
      end

      perform_additional_validation do |resource, profile_url|
        ProvenanceValidator.validate(resource) if resource.instance_of?(FHIR::Provenance)
      end
    end

    input :reports,
    title: 'Cancer Reports',
    description: 'Comma-Separated Content Bundle(s)',
    type: 'textarea'

    group from: :exchange_bundle_group

  end
end
