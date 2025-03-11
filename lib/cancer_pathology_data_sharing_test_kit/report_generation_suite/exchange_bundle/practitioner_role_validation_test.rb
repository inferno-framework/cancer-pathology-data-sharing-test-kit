require_relative '../../bundle_parse'
require_relative '../../validation_test'

module CancerPathologyDataSharingTestKit
  class PractitionerRoleValidationTest < Inferno::Test
    include CancerPathologyDataSharingTestKit::ValidationTest
    include CancerPathologyDataSharingTestKit::BundleParse

    title 'PractitionerRole resources in the bundle(s) conforms to the US Pathology PractitionerRole profile'
    description %(
    This test verifies that any PractitionerRole resources from each bundle conforms to
    the [US Pathology Related PractitionerRoles](http://hl7.org/fhir/us/cancer-reporting/StructureDefinition/us-pathology-related-practitioner-role).

    It verifies the presence of mandatory elements and that elements with
    required bindings contain appropriate values. CodeableConcept element
    bindings will fail if none of their codings have a code/system belonging
    to the bound ValueSet. Quantity, Coding, and code element bindings will
    fail if their code/system are not found in the valueset.
    )

    id :practitioner_role_validation_test

    def resource_type
      'PractitionerRole'
    end

    run do
      invalid_bundles = []
      total_resources = 0
      scratch[:cpds_resources].each do |bundle_id, bundle_resources|
        resources = bundle_resources['PractitionerRole'] || []
        total_resources += resources.length

        profile_url = PE_BUNDLE_SLICE_RESOURCES['PractitionerRole']
        invalid_bundles << bundle_id if perform_strict_validation_test('PractitionerRole', bundle_id, resources, profile_url, '1.0.1', skip_if_empty: false)
      end

      skip_if total_resources == 0,
        "No #{resource_type} resources found in any of the given bundles"

      check_for_errors(invalid_bundles)
    end
  end
end