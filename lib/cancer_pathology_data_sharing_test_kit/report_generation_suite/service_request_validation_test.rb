require_relative '../bundle_parse'
require_relative '../validation_test'

module CancerPathologyDataSharingTestKit
  class ServiceRequestValidationTest < Inferno::Test
    include CancerPathologyDataSharingTestKit::ValidationTest
    include CancerPathologyDataSharingTestKit::BundleParse

    title 'ServiceRequest resources confirm to the US Pathology ServiceRequest profile'
    description %(
    This test verifies at least one of the Encounter resources returned from each bundle conforms to
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
      scratch[:cpds].each do |bundle_resources|
        resources = bundle_resources['ServiceRequest']

        # Go ahead and skip if resources is all empty
        skip_if resources.blank?, "No #{resource_type} resources were returned."

        profile_url = PE_BUNDLE_SLICE_RESOURCES['ServiceRequest']
        perform_validation_test('ServiceRequest', resources, profile_url, '1.0.1')
      end
    end
  end
end