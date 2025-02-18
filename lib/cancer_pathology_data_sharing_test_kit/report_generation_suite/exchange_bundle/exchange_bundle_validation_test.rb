# frozen_string_literal: true
require_relative '../../bundle_parse'
require_relative '../../validation_test'
require_relative '../../generator/naming'

module CancerPathologyDataSharingTestKit
  class ContentBundleValidationTest < Inferno::Test
    include CancerPathologyDataSharingTestKit::ValidationTest
    include CancerPathologyDataSharingTestKit::BundleParse
    title 'Provided Bundle resources conform to the US Pathology Exchange Bundle Profile'
    id :exchange_bundle_validation_test

    description %(
        Verify that all the generated report(s) are a conformant
        [Pathology Exchange Bundle](http://hl7.org/fhir/us/cancer-reporting/StructureDefinition/us-pathology-exchange-bundle.html).
      )
  
      def init_scratch
        scratch ||= {}
      end

      def resource_type
        'Bundle'
      end


      def add_to_scratch(bundles_array)
        scratch[:cpds_resources] ||= {}
        scratch[:cpds_exchange_bundles] ||= []
        bundles_array.each do |report| 
          bundle = FHIR.from_contents(report.to_json)
          assert_resource_type('Bundle', resource: bundle)
          bundle_id = bundle.id
          # bundle_id = '1'
          scratch[:cpds_exchange_bundles] << bundle
          scratch[:cpds_resources][bundle_id] = parse_bundle(bundle)
        end
      end
  
      run do
        # TODO: For now, no validation on the input, assume it's correct
        # Put reports into array to process
        bundles_array = JSON.parse('[' + reports + ']')
        add_to_scratch(bundles_array)
  
        invalid_bundles = []
        profile_with_version = 'http://hl7.org/fhir/us/cancer-reporting/StructureDefinition/us-pathology-exchange-bundle|1.0.1'
        bundles_array.each do |bundle|
          fhir_bundle = FHIR.from_contents(bundle.to_json)
          invalid_bundles << fhir_bundle.id if !resource_is_valid?(resource: fhir_bundle, profile_url: profile_with_version)
        end
  
        errors_found = messages.any? { |message| message[:type] == 'error' }
        assert !errors_found, "Bundle(s) #{invalid_bundles.join(', ')} do not conform to the profile #{profile_with_version}"
      end
  end
end