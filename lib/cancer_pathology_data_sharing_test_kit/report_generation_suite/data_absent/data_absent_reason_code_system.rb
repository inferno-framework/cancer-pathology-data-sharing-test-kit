module CancerPathologyDataSharingTestKit
  class DataAbsentReasonCodeSystem < Inferno::Test
    id :cpds_data_absent_reason_code_system
    title 'Server represents missing data with the DataAbsentReason CodeSystem'
    description %(
      For coded data elements (fields bound to value sets), the CPDS IG specifies how to handle missing data:

      Primary Approach:
      * If the value set includes an appropriate "unknown" code, that code SHALL be used
      * Example: Using SNOMED CT "unknown" code for fields bound to SNOMED CT value sets

      Alternative Approach:
      * For value sets with example, preferred, or extensible binding strengths that do not include
        an appropriate "unknown" code, servers SHALL use the "unknown" code from the
        [DataAbsentReason CodeSystem](http://hl7.org/fhir/R4/codesystem-data-absent-reason.html)
      * This ensures consistent representation of unknown values across all coded fields

      This test validates that when appropriate "unknown" codes are not available in the bound
      value sets, the system correctly uses the DataAbsentReason CodeSystem's "unknown" code
      to represent missing data in coded fields.

      Note: This is different from the DataAbsentReason Extension, which is used for non-coded
      fields. The DataAbsentReason CodeSystem is specifically for coded fields where the bound
      value set lacks an appropriate "unknown" code.
    )
    input :dar_code_found,
          title: 'Data Absent Reason CodeSystem Found',
          locked: true,
          optional: true,
          default: 'false'

    run do
      assert dar_code_found == 'true',
             'No resources using the DataAbsentReason CodeSystem have been found'
    end
  end
end
