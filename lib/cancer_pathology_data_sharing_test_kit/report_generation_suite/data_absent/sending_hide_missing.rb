module CancerPathologyDataSharingTestKit
  class SendingHideMissing < Inferno::Test
    id :cpds_data_absent_sending_hide_missing
    title 'Sender does not send data element(s) with missing information'
    description %(
        In situations where information on a particular data element is not present, the Sender SHALL NOT include the data element
       in the resource instance if the cardinality is 0..n.
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
