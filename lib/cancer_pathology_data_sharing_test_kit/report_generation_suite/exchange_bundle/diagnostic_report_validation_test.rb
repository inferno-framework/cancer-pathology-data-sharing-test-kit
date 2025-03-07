require_relative '../../bundle_parse'
require_relative '../../validation_test'
require_relative '../../generator/naming'

module CancerPathologyDataSharingTestKit
  class DiagnosticReportValidationTest < Inferno::Test
    include CancerPathologyDataSharingTestKit::ValidationTest
    include CancerPathologyDataSharingTestKit::BundleParse

    title 'DiagnosticReport resource in each bundle conforms to the US Pathology Diagnostic Report profile'
    description %(
    This test verifies that there is exactly one DiagnosticReport resource returned from each bundle and that it conforms to
    the [US Pathology Diagnostic Report](http://hl7.org/fhir/us/cancer-reporting/StructureDefinition/us-pathology-diagnostic-report).

    It verifies the presence of mandatory elements and that elements with
    required bindings contain appropriate values. CodeableConcept element
    bindings will fail if none of their codings have a code/system belonging
    to the bound ValueSet. Quantity, Coding, and code element bindings will
    fail if their code/system are not found in the valueset.
    )

    id :diagnostic_report_validation_test

    def resource_type
      'DiagnosticReport'
    end

    run do
      invalid_bundles = []
      total_resources = 0
      scratch[:cpds_resources].each do |bundle_id, bundle_resources|
        resources = bundle_resources['DiagnosticReport'] || []
        total_resources += resources.length

        profile_url = PE_BUNDLE_SLICE_RESOURCES['DiagnosticReport']
        invalid_bundles << bundle_id if perform_strict_validation_test('DiagnosticReport', bundle_id, resources, profile_url, '1.0.1', restriction: "exactly_one")
      end

      skip_if total_resources == 0,
        "No #{resource_type} resources found in any of the given bundles"

      check_for_errors(invalid_bundles)

    end
  end
end