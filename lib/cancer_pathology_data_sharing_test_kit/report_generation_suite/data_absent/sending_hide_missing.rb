module CancerPathologyDataSharingTestKit
  class SendingHideMissing < Inferno::Test
    id :cpds_data_absent_sending_hide_missing
    title 'Sender does not send data element(s) with missing information'
    description %(
      The CPDS IG provides specific guidance for handling optional data elements (those with cardinality 0..n)
      when the information is not available. This requirement helps reduce message size and processing overhead
      while maintaining semantic clarity.

      Key Requirements:
      * When information for an optional data element is not available, the Sender SHALL NOT include
        the empty element in the resource instance
      * This applies only to elements with cardinality 0..n (optional elements)
      * For required elements (cardinality 1..n or 1..1), use the appropriate missing data pattern instead:
        * DataAbsentReason Extension for non-coded fields
        * "Unknown" codes from value sets for coded fields

      Examples:
      * DO NOT include an empty 'note' element if there are no notes
      * DO NOT include an empty 'identifier' array if there are no identifiers
      * DO NOT include null or empty string values in optional elements

      This test verifies that the system correctly omits optional elements when their data is not available,
      rather than including them with empty or null values.
    )

    run do
      identifier = SecureRandom.hex(32)
      wait(
        identifier:,
        message: <<~MESSAGE
          The system under test has demonstrated that it meets the following [requirement](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/specification.html#must-support-and-missing-data):

          [Specifically](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/specification.html#must-support-and-missing-data)

          > Sending Systems [of the [US Pathology Bundle](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/StructureDefinition-us-pathology-exchange-bundle.html)] In situations where information on a particular data element is not present, the Sender SHALL NOT include the data element in the resource instance if the cardinality is 0..n.

          [Click here](#{resume_pass_url}?token=#{identifier}) if the system **meets** this requirement.

          [Click here](#{resume_fail_url}?token=#{identifier}) if the system **does not meet** this requirement.
        MESSAGE
      )
    end
  end
end
