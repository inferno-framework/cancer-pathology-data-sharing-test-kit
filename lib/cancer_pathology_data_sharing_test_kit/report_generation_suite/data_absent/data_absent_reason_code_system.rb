module CancerPathologyDataSharingTestKit
  class DataAbsentReasonCodeSystem < Inferno::Test
    id :cpds_data_absent_reason_code_system
    title 'Server represents missing data with the DataAbsentReason CodeSystem'
    description %(
            For coded data elements with example, preferred, or extensible binding
            strengths to ValueSets which do not include an appropriate "unknown"
            code, servers SHALL use the "unknown" code from the DataAbsentReason
            CodeSystem.
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
