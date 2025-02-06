require_relative '../bundle_parse'

module CancerPathologyDataSharingTestKit
  class CancerPathologyDataSharingBundleTest < Inferno::Test
    include CancerPathologyDataSharingTestKit::BundleParse

    title 'Bundle Generation'
    description %()

    id :cpds_bundle_generation_test

    def add_to_scratch(bundles_array)
      scratch[:cpds] ||= []
      bundles_array.each do |report| 
        bundle = FHIR.from_contents(report.to_json)
        scratch[:cpds] << parse_bundle(bundle)
      end
    end

    run do
      # TODO: For now, no validation on the input, assume it's correct
      # Put reports into array to process
      bundles_array = JSON.parse('[' + reports + ']')
      add_to_scratch(bundles_array)

      profile_with_version = 'http://hl7.org/fhir/us/cancer-reporting/StructureDefinition/us-pathology-exchange-bundle|1.0.1'
      bundles_array.each do |bundle|
        fhir_bundle = FHIR.from_contents(bundle.to_json)
        resource_is_valid?(resource: fhir_bundle, profile_url: profile_with_version)
      end

      errors_found = messages.any? { |message| message[:type] == 'error' }
      assert !errors_found, "Bundle does not conform to the profile #{profile_with_version}"
    end
  end
end
