module CancerPathologyDataSharingTestKit
  class DataAbsentReasonExtension < Inferno::Test
    id :cpds_data_absent_reason_extension
    title 'Server represents missing data with the DataAbsentReason Extension'
    description %(
            For non-coded data elements, servers SHALL use the DataAbsentReason
            Extension to represent missing data in a required field
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
