require_relative 'version'

module CancerPathologyDataSharingTestKit
  class Metadata < Inferno::TestKit
    id :cancer_pathology_data_sharing_test_kit
    title 'Cancer Pathology Data Sharing Test Kit'
    description <<~DESCRIPTION

      The Cancer Pathology Data Sharing (CPDS) Test Kit is a testing tool for Health IT systems
      seeking to meet the requirements of the STU 1.0.0 version of the HL7® FHIR®
      [Cancer Pathology Data Sharing IG](https://hl7.org/fhir/us/cancer-reporting/STU1.0.1/).

      <!-- break -->

      This test kit currently contains suites that verify the conformance of systems playing the following roles:
      - **Report Generation**: Verifies that the Health IT system can generate
        conformant and complete cancer pathology reports to send to a cancer registry.
      - **Data Access**: Verifies that the Health IT system can respond to queries
        for the data needed to create a cancer pathology report.

      ## Getting Started

      To run CPDS tests, select the suite corresponding to the functionality you wish to test
      and click ‘Create Test Session’.

      ## Status

      These tests are a **DRAFT** intended to allow CPDS IG implementers to
      perform preliminary checks of their implementations against the IG's requirements and provide feedback
      on the tests. Future versions of these tests may validate other requirements and may change how these
      are tested.

      ## Known Limitations

      This test kit does not currently include test suites for all actors and all capabilities defined by the CPDS IG.
      Out of scope areas of the IG include the Cancer Registry actor and details related to the use of the
      [MedMorph framework](https://hl7.org/fhir/us/medmorph/STU1/) by all actors to coordinate reporting triggering,
      report content, and report delivery requirements.

      The existing Report Generation and Data Access suites focus on report content and do not currently
      test most details of the report exchange workflow. The following areas are not tested:
      - Data Access requirements around authentication and authorization.
      - Report Generation requirements around the gathering of report contents from clinical systems and the
        delivery of completed reports using FHIR APIs.

      For additional details on suite-specific limitations, see the suite documention in the running tests or the
      corresponding content in the source repository ([Data Access suite limitations](https://github.com/inferno-framework/cancer-pathology-data-sharing-test-kit/blob/main/lib/cancer_pathology_data_sharing_test_kit/docs/data_access_suite_description.md#current-limitations),
      [Report Generation suite limitations](https://github.com/inferno-framework/cancer-pathology-data-sharing-test-kit/blob/main/lib/cancer_pathology_data_sharing_test_kit/docs/report_generation_suite_description.md#current-limitations))

      ## Repository and Resources

      The Cancer Pathology Data Sharing Test Kit can be [downloaded](https://github.com/inferno-framework/cancer-pathology-data-sharing-test-kit/releases)
      from its [GitHub repository](https://github.com/inferno-framework/cancer-pathology-data-sharing-test-kit).

      ## Providing Feedback and Reporting Issues

      We welcome feedback on the tests, including but not limited to the following areas:
      - Validation logic, such as potential bugs, lax checks, and unexpected failures.
      - Requirements coverage, such as requirements that have been missed, tests that necessitate features that the
        IG does not require, or other issues with the interpretation of the IG’s requirements.
      - User experience, such as confusing or missing information in the test UI.

      Please report any issues with this set of tests in the [issues section](https://github.com/inferno-framework/cancer-pathology-data-sharing-test-kit/issues)
      of the repository.

    DESCRIPTION
    suite_ids [:cpds_report_generation, :cpds_data_access]
    tags []
    last_updated LAST_UPDATED
    version VERSION
    maturity 'Low'
    authors ['MITRE Inferno Team']
    repo 'https://github.com/inferno-framework/cancer-pathology-data-sharing-test-kit/'
  end
end
