module CancerPathologyDataSharingTestKit
  class DataAbsentReasonExtension < Inferno::Test
    id :cpds_data_absent_reason_extension
    title 'DataAbsentReason Extension Implementation for Non-Coded Fields'
    description %(
      The Cancer Pathology Data Sharing IG requires specific handling of missing data in required fields.
      For non-coded fields that are required but the data is not available, systems SHALL use the
      [DataAbsentReason Extension](http://hl7.org/fhir/StructureDefinition/data-absent-reason) to explicitly
      indicate why the data is not present.

      The extension must be used with one of these values to indicate why data is missing:
      * unknown - The value is not known and there is no expectation that it will be known
      * asked-unknown - The source was queried but does not know the value
      * temp-unknown - The value is not known at this time but is expected to be known later
      * not-asked - The source was not asked for the value
      * asked-declined - The source was asked for the value but declined to answer
      * masked - The information is available but not provided due to security, privacy, or other reasons
      * not-applicable - The field is not applicable to this concept
      * unsupported - The source system does not support this field
      * as-text - The information is available but only as text
      * error - The information is not available due to an error
      * not-performed - The task/step associated with this element was not performed
      * not-permitted - The user does not have the necessary rights to view this information

      This test validates that the system properly implements this extension pattern when representing
      missing non-coded data elements, as specified in the [CPDS Missing Data Guidance](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/specification.html#must-support-and-missing-data).

      For coded fields (those bound to value sets), systems should instead use the appropriate "unknown" code
      from the value set rather than the DataAbsentReason extension.
    )
    input :dar_extension_found,
          title: 'Data Absent Reason Extension Found',
          locked: true,
          optional: true,
          default: 'false'

    run do
      assert dar_extension_found == 'true',
             'No resources using the DataAbsentReason Extension have been found'
    end
  end
end
