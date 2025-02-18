require_relative '../../bundle_parse'
require_relative '../../validation_test'
require_relative '../../generator/naming'

module CancerPathologyDataSharingTestKit
  class SpecimenValidationTest < Inferno::Test
    include CancerPathologyDataSharingTestKit::ValidationTest
    include CancerPathologyDataSharingTestKit::BundleParse

    title 'At least one of the Specimen resources in the bundle(s) conforms to the US Pathology Specimen profile'
    description %(
    This test verifies at least one of the Encounter resources returned from each bundle conforms to
    the [US Pathology Specimen](http://hl7.org/fhir/us/cancer-reporting/StructureDefinition/us-pathology-specimen).

    It verifies the presence of mandatory elements and that elements with
    required bindings contain appropriate values. CodeableConcept element
    bindings will fail if none of their codings have a code/system belonging
    to the bound ValueSet. Quantity, Coding, and code element bindings will
    fail if their code/system are not found in the valueset.
    )

    id :specimen_validation_test

    def resource_type
      'Specimen'
    end

    run do
      scratch[:cpds_resources].each do |bundle_id, bundle_resources|
        resources = bundle_resources['Specimen']

        # Go ahead and skip if resources is all empty
        skip_if resources.blank?, "No #{resource_type} resources were returned."

        profile_url = PE_BUNDLE_SLICE_RESOURCES['Specimen']
        perform_strict_validation_test('Specimen',bundle_id, resources, profile_url, '1.0.1')
        assert (resources.length >= 1), "There must be at least one (1) #{resource_type} resource per bundle. Bundle `#{bundle_id}` has #{resources.length} resources"
      end
    end
  end
end