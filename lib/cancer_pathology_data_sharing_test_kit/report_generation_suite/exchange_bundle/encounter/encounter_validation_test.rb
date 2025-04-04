require_relative '../../../bundle_parse'
require_relative '../../../validation_test'

module CancerPathologyDataSharingTestKit
  class EncounterValidationTest < Inferno::Test
    include CancerPathologyDataSharingTestKit::ValidationTest
    include CancerPathologyDataSharingTestKit::BundleParse

    title 'Encounter resource in each bundle conforms to the US Core Encounter profile'
    description %(
    This test verifies that any Encounter resource returned from each bundle conforms to
    the [US Core Encounter Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter).

    It verifies the presence of mandatory elements and that elements with
    required bindings contain appropriate values. CodeableConcept element
    bindings will fail if none of their codings have a code/system belonging
    to the bound ValueSet. Quantity, Coding, and code element bindings will
    fail if their code/system are not found in the valueset.
    )

    id :cpds_encounter_validation_test

    def resource_type
      'Encounter'
    end

    output :dar_code_found, :dar_extension_found

    run do
      invalid_bundles = []
      total_resources = 0
      scratch[:cpds_resources].each do |bundle_id, bundle_resources|
        resources = bundle_resources['Encounter'] || []
        total_resources += resources.length

        profile_url = PE_BUNDLE_SLICE_RESOURCES['Encounter']
        invalid_bundles << bundle_id if perform_strict_validation_test('Encounter', bundle_id, resources, profile_url,
                                                                       '5.0.1', skip_if_empty: false,
                                                                                restriction: 'no_more_than_one')
      end

      skip_if total_resources.zero?,
              "No #{resource_type} resources found in any of the given bundles"

      check_for_errors(invalid_bundles)
    end
  end
end
