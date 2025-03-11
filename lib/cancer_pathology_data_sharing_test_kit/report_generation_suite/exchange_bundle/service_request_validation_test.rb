require_relative '../../bundle_parse'
require_relative '../../validation_test'

module CancerPathologyDataSharingTestKit
  class ServiceRequestValidationTest < Inferno::Test
    include CancerPathologyDataSharingTestKit::ValidationTest
    include CancerPathologyDataSharingTestKit::BundleParse

    title 'ServiceRequest resources in the bundle(s) conforms to the US Pathology ServiceRequest profile'
    description %(
    This test verifies that any ServiceRequest resources from each bundle conforms to
    the [US Pathology Service Request](http://hl7.org/fhir/us/cancer-reporting/StructureDefinition/us-pathology-service-request).

    It verifies the presence of mandatory elements and that elements with
    required bindings contain appropriate values. CodeableConcept element
    bindings will fail if none of their codings have a code/system belonging
    to the bound ValueSet. Quantity, Coding, and code element bindings will
    fail if their code/system are not found in the valueset.
    )

    id :service_request_validation_test

    def resource_type
      'ServiceRequest'
    end

    run do
      invalid_bundles = []
      total_resources = 0
      scratch[:cpds_resources].each do |bundle_id, bundle_resources|
        resources = bundle_resources['ServiceRequest'] || []
        total_resources += resources.length

        profile_url = PE_BUNDLE_SLICE_RESOURCES['ServiceRequest']
        invalid_bundles << bundle_id if perform_strict_validation_test('ServiceRequest', bundle_id, resources, profile_url, '1.0.1', skip_if_empty: false)
      end

      skip_if total_resources == 0,
        "No #{resource_type} resources found in any of the given bundles"

      check_for_errors(invalid_bundles)
    end
  end
end