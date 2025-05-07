require_relative 'data_absent/sending_hide_missing'
require_relative 'data_absent/data_absent_reason_extension'
require_relative 'data_absent/data_absent_reason_code_system'

module CancerPathologyDataSharingTestKit
  class DataAbsentGroup < Inferno::TestGroup
    id :cpds_data_absent_reason
    title 'Missing Data Tests'
    short_description 'Verify that the server is capable of representing missing data.'

    description %(
      The [CPDS Missing Data
      Guidance](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/specification.html#must-support-and-missing-data)
      gives instructions on how to represent various types of missing data.

      In the previous resource tests, each resource returned from the server was
      checked for the presence of missing data. These tests will pass if the
      specified method of representing missing data was observed in the earlier
      tests.
    )
    run_as_group

    test from: :cpds_data_absent_sending_hide_missing
    test from: :cpds_data_absent_reason_extension
    test from: :cpds_data_absent_reason_code_system
  end
end
