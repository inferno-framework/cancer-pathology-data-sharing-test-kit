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
    end
  end
end
