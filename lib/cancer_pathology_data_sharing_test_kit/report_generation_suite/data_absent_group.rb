require_relative 'data_absent/sending_hide_missing'
require_relative 'data_absent/data_absent_reason_extension'
require_relative 'data_absent/data_absent_reason_code_system'

module CancerPathologyDataSharingTestKit
  class DataAbsentGroup < Inferno::TestGroup
    id :cpds_data_absent_reason
    title 'Cancer Pathology Missing Data Representation'
    short_description 'Verify compliance with CPDS IG missing data requirements.'

    description %(
      The Cancer Pathology Data Sharing IG provides specific [Missing Data Guidance](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/specification.html#must-support-and-missing-data)
      for handling required data elements that may not be available. The IG defines different approaches based on the type of field:

      For Non-Coded Fields:
      * Systems SHALL use the DataAbsentReason Extension to explicitly indicate why required data is missing
      * The extension must use standardized codes like 'unknown', 'asked-unknown', 'temp-unknown', etc.
      * This applies to string, dateTime, and other non-coded fields

      For Coded Fields (bound to ValueSets):
      * Systems SHALL use the appropriate "unknown" code from the specified value set
      * The DataAbsentReason Extension should NOT be used for these fields
      * Example: Using "unknown" SNOMED CT code for a field bound to SNOMED CT concepts

      Display Requirements:
      * Systems SHALL support the ability to hide missing data in displays
      * This helps reduce visual clutter while still maintaining the complete data
      * Display preferences should be configurable by users

      These tests validate that resources properly implement all three aspects of missing data handling:
      1. Correct use of DataAbsentReason Extension for non-coded fields
      2. Proper use of "unknown" codes from value sets for coded fields
      3. Support for configurable display of missing data

      Each resource previously tested has been analyzed for correct implementation of these missing data patterns
      as specified in the IG.
    )
    run_as_group

    test from: :cpds_data_absent_sending_hide_missing
    test from: :cpds_data_absent_reason_extension
    test from: :cpds_data_absent_reason_code_system
  end
end
