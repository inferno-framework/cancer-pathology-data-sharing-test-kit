require_relative '../bundle_parse'

module CancerPathologyDataSharingTestKit
  class CancerPathologyDataSharingBundleTest < Inferno::Test
    include CancerPathologyDataSharingTestKit::BundleParse

    title 'Bundle Generation'
    description %()

    id :cpds_bundle_generation_test

    def init_scratch
      scratch ||= {}
    end

    def add_to_scratch(bundles_array)
      init_scratch
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

      # TODO: This just makes it easily displayed in the GUI for now to verify
      messages << { message: scratch[:cpds].map { |resources| resources.keys }.to_s, type: 'info' }
      messages << { message: scratch[:cpds].map { |resources| filter_exchange_bundle_resources(resources).keys }.to_s, type: 'info' }
      messages << { message: scratch.to_json.to_s, type: 'info' }
    end
  end
end
