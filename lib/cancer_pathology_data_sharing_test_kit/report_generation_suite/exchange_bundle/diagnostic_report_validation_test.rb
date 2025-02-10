require_relative '../../bundle_parse'
require_relative '../../validation_test'

module CancerPathologyDataSharingTestKit
  class DiagnosticReportValidationTest < Inferno::Test
    include CancerPathologyDataSharingTestKit::ValidationTest
    include CancerPathologyDataSharingTestKit::BundleParse

    title 'At least one of the DiagnosticReport resources in the bundle(s) conforms to the US Pathology Diagnostic Report profile'
    description %(
    This test verifies at least one of the DiagnosticReport resources returned from each bundle conforms to
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
      scratch[:cpds_resources].each do |bundle_resources|
        resources = bundle_resources['DiagnosticReport']

        # Go ahead and skip if resources is all empty
        skip_if resources.blank?, "No #{resource_type} resources were returned."

        profile_url = PE_BUNDLE_SLICE_RESOURCES['DiagnosticReport']
        perform_validation_test('DiagnosticReport', resources, profile_url, '1.0.1')
      end
    end
  end
end