require_relative '../bundle_parse'
require_relative '../validation_test'

module CancerPathologyDataSharingTestKit
  class DiagnosticReportValidationTest < Inferno::Test
    include CancerPathologyDataSharingTestKit::ValidationTest
    include CancerPathologyDataSharingTestKit::BundleParse

    title 'DiagnosticReport resources confirm to the US Pathology Diagnostic Report profile'
    description %()

    id :diagnostic_report_validation_test

    def resource_type
      'DiagnosticReport'
    end

    run do
      scratch[:cpds].each do |bundle_resources|
        resources = bundle_resources['DiagnosticReport']

        # Go ahead and skip if resources is all empty
        skip_if resources.blank?, "No #{resource_type} resources were returned."

        profile_url = PE_BUNDLE_SLICE_RESOURCES['DiagnosticReport']
        perform_validation_test('DiagnosticReport', resources, profile_url, '1.0.1')
      end
    end
  end
end