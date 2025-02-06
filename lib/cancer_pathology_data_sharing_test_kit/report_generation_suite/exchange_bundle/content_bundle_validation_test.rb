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

      def add_ms_resources_to_scratch(reports)
        reports.each do |bundle|
          fhir_bundle = FHIR.from_contents(bundle.to_json)
          assert_resource_type('Bundle', resource: fhir_bundle)
          report_hash = url_keys_to_group_keys(parse_bundle(fhir_bundle))
          report_hash[:cpds_exchange_bundle_resources] ||= []
          report_hash[:cpds_exchange_bundle_resources] << fhir_bundle
          report_hash.each do |group, resources|
            scratch[group] ||= {}
            scratch[group][:all] ||= []
            scratch[group][:all].concat(resources)
          end
        end
      end

      def url_keys_to_group_keys(report_hash)
        report_hash.transform_keys { |key| "#{key.downcase}_resources".to_sym}
      end


      def resource_type
        'Bundle'
      end

      def scratch_resources
        scratch[:cpds_exchange_bundle_resources] ||= {}
      end

      run do
        init_scratch
        add_ms_resources_to_scratch(JSON.parse("[" + reports + "]"))
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/us/cancer-reporting/StructureDefinition/us-pathology-exchange-bundle',
                                '1.0.1',
                                skip_if_empty: true)
      end
  end
end