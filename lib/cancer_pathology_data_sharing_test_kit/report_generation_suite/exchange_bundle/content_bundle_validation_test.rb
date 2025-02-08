# frozen_string_literal: true
require_relative '../../bundle_parse'
require_relative '../../validation_test'
require_relative '../../generator/naming'
module CancerPathologyDataSharingTestKit
  class ContentBundleValidationTest < Inferno::Test
    include CancerPathologyDataSharingTestKit::ValidationTest
    include CancerPathologyDataSharingTestKit::BundleParse
    title 'Pathology Exchange Bundle Validation Test'
    id :content_bundle_validation_test

    description %(
        Verify that the generated report is a conformant
        [Pathology Exchange Bundle](http://hl7.org/fhir/us/cancer-reporting/StructureDefinition/us-pathology-exchange-bundle.html).
      )
  
      def init_scratch
        scratch ||= {}
      end

      # def add_ms_resources_to_scratch(reports)
      #   reports.each do |bundle|
      #     fhir_bundle = FHIR.from_contents(bundle.to_json)
      #     assert_resource_type('Bundle', resource: fhir_bundle)
      #     report_hash = url_keys_to_group_keys(parse_bundle(fhir_bundle))
      #     report_hash[:cpds_exchange_bundle_resources] ||= []
      #     report_hash[:cpds_exchange_bundle_resources] << fhir_bundle
      #     report_hash.each do |group, resources|
      #       scratch[group] ||= {}
      #       scratch[group][:all] ||= []
      #       scratch[group][:all].concat(resources)
      #     end
      #   end
      # end

      # def url_keys_to_group_keys(report_hash)
      #   report_hash.transform_keys { |key| "#{key.downcase}_resources".to_sym}
      # end


      def resource_type
        'Bundle'
      end


      def add_to_scratch(bundles_array)
        scratch[:cpds_resources] ||= []
        scratch[:cpds_exchange_bundles] ||= []
        bundles_array.each do |report| 
          bundle = FHIR.from_contents(report.to_json)
          assert_resource_type('Bundle', resource: bundle)
          scratch[:cpds_exchange_bundles] << bundle
          scratch[:cpds_resources] << parse_bundle(bundle)
        end
      end
  
      run do
        # TODO: For now, no validation on the input, assume it's correct
        # Put reports into array to process
        bundles_array = JSON.parse('[' + reports + ']')
        add_to_scratch(bundles_array)
  
        profile_with_version = 'http://hl7.org/fhir/us/cancer-reporting/StructureDefinition/us-pathology-exchange-bundle|1.0.1'
        bundles_array.each do |bundle|
          fhir_bundle = FHIR.from_contents(bundle.to_json)
          resource_is_valid?(resource: fhir_bundle, profile_url: profile_with_version)
        end
  
        errors_found = messages.any? { |message| message[:type] == 'error' }
        assert !errors_found, "Bundle does not conform to the profile #{profile_with_version}"
      end
  end
end