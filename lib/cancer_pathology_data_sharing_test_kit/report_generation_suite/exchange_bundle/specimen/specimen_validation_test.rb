require_relative '../../../bundle_parse'
require_relative '../../../validation_test'

module CancerPathologyDataSharingTestKit
  class SpecimenValidationTest < Inferno::Test
    include CancerPathologyDataSharingTestKit::ValidationTest
    include CancerPathologyDataSharingTestKit::BundleParse

    title 'Specimen resources in the bundle(s) conforms to the US Pathology Specimen profile'
    description %(
    This test verifies there is at least one of the Specimen resource returned from each bundle and that it conforms to
    the [US Pathology Specimen](http://hl7.org/fhir/us/cancer-reporting/StructureDefinition/us-pathology-specimen).

    It verifies the presence of mandatory elements and that elements with
    required bindings contain appropriate values. CodeableConcept element
    bindings will fail if none of their codings have a code/system belonging
    to the bound ValueSet. Quantity, Coding, and code element bindings will
    fail if their code/system are not found in the valueset.
    )

    id :cpds_specimen_validation_test

    def resource_type
      'Specimen'
    end

    output :dar_code_found, :dar_extension_found

    run do
      invalid_bundles = []
      total_resources = 0
      scratch[:cpds_resources].each do |bundle_id, bundle_resources|
        resources = bundle_resources['Specimen'] || []
        total_resources += resources.length

        profile_url = PE_BUNDLE_SLICE_RESOURCES['Specimen']
        invalid_bundles << bundle_id if perform_strict_validation_test('Specimen', bundle_id, resources, profile_url, '1.0.1',
                                                                       restriction: 'at_least_one')
      end

      skip_if total_resources.zero?,
              "No #{resource_type} resources found in any of the given bundles"

      check_for_errors(invalid_bundles)
    end
  end
end
