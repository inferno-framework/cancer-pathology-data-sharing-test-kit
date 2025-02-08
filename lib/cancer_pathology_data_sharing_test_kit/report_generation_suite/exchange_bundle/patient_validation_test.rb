require_relative '../../bundle_parse'
require_relative '../../validation_test'

module CancerPathologyDataSharingTestKit
  class PatientValidationTest < Inferno::Test
    include CancerPathologyDataSharingTestKit::ValidationTest
    include CancerPathologyDataSharingTestKit::BundleParse

    title 'Patient resources confirm to the US Core Patient profile'
    description %(
    This test verifies at least one of the Encounter resources returned from each bundle conforms to
    the [US Core Patient Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient).

    It verifies the presence of mandatory elements and that elements with
    required bindings contain appropriate values. CodeableConcept element
    bindings will fail if none of their codings have a code/system belonging
    to the bound ValueSet. Quantity, Coding, and code element bindings will
    fail if their code/system are not found in the valueset.
    )

    id :patient_validation_test

    def resource_type
      'Patient'
    end

    run do
      scratch[:cpds_resources].each do |bundle_resources|
        resources = bundle_resources['Patient']

        # Go ahead and skip if resources is all empty
        skip_if resources.blank?, "No #{resource_type} resources were returned."

        profile_url = PE_BUNDLE_SLICE_RESOURCES['Patient']
        perform_validation_test('Patient', resources, profile_url, '5.0.1')
      end
    end
  end
end