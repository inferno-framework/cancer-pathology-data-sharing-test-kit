RSpec.describe CancerPathologyDataSharingTestKit::MustSupportTest, :runnable do # rubocop:disable RSpec/SpecFilePathFormat
  let(:suite_id) { 'cpds_report_generation' }
  let(:suite) { Inferno::Repositories::TestSuites.new.find(suite_id) }
  let(:session_data_repo) { Inferno::Repositories::SessionData.new }
  let(:runner) { Inferno::TestRunner.new(test_session: test_session, test_run: test_run) }
  let(:test_session) do
    Inferno::Repositories::TestSessions.new.create(test_suite_id: suite.id)
  end
  let(:request_repo) { Inferno::Repositories::Requests.new }
  let(:group) { suite.groups.find { |g| g.id.include?('exchange_bundle_group') } }

  # Required explicitly here because MustSupportTest is a module and not Inferno::DSL::Runnable
  include_context 'when testing a runnable'

  describe 'must_support_test' do
    let(:test) do
      group.groups.find { |g| g.title == 'Specimen' }.tests.find { |t| t.id.include?('v101_specimen_must_support_test') }
    end
    let(:url) { 'http://example.com/hc' }
    let(:operation_outcome_success) do
      {
        outcomes: [{
          issues: []
        }],
        sessionId: 'b8cf5547-1dc7-4714-a797-dc2347b93fe2'
      }
    end

    let(:fhir_specimen_complete_example) do
      FHIR::Specimen.new(
        resourceType: 'Encounter',
        id: 'uspath-specimen-collection-example',
        meta: {
          versionId: '1',
          lastUpdated: '2022-04-17T13:46:33.150+00:00',
          source: '#crGIzXgvY3vm6ixN',
          profile: ['http://hl7.org/fhir/us/core/StructureDefinition/us-core-encounter']
        },
        identifier: [{
          system: 'http://example.com/fhir/encounters',
          value: '123'
        }],
        status: 'finished',
        class: {
          system: 'http://terminology.hl7.org/CodeSystem/v3-ActCode',
          code: 'IMP',
          display: 'inpatient encounter'
        },
        note: {
          authorString: 'example2',
          authorReference: {
            reference: 'PractitionerRole/example2'
          }
        },
        receivedTime: '2024-12-05T13:52:02+00:00',
        collection: {
          collectedDateTime: '2024-12-05T14:52:02+00:00',
          method: {
            coding: [
              {
                system: 'http://snomed.info/sct',
                code: '65801008',
                display: 'Excision (procedure)'
              }
            ]
          },
          bodySite: {
            coding: [
              {
                system: 'http://snomed.info/sct',
                code: '107008',
                display: 'Fetal part of placenta'
              }
            ]
          },
          collector: {
            reference: 'PractitionerRole/example2'
          }
        },
        parent: {
          reference: 'Specimen/example1'
        },
        accessionIdentifier: {
          system: 'http://some-lis.org/fhir/specimen-identifier-provisioner',
          value: '987654321X'
        },
        container: [
          {
            identifier: [
              {
                system: 'http://some-lis.org/fhir/specimen-containerID-provisioner',
                value: '123456789'
              }
            ],
            type: {
              coding: [
                {
                  system: 'http://snomed.info/sct',
                  code: '434711009',
                  display: 'Specimen container (physical object)'
                }
              ]
            }
          }
        ],
        type: [{
          coding: [{
            system: 'http://snomed.info/sct',
            code: '726007',
            display: 'Pathology consultation, comprehensive, records and specimen with report'
          }]
        }],
        subject: {
          reference: 'Patient/JoelAlexPatient'
        },
        participant: [{
          individual: {
            reference: 'Practitioner/oncologist-example'
          }
        },
                      {
                        individual: {
                          reference: 'Practitioner/pathologist-example'
                        }
                      }]
      )
    end

    let(:fhir_specimen_incomplete_example) do
      FHIR::Specimen.new(
        resourceType: 'Encounter',
        id: 'uspath-specimen-collection-example'
      )
    end

    it 'passes if the input is contains all Must Supports' do
      allow_any_instance_of(test).to receive(:scratch).and_return({ cpds_resources: { temp: { 'Specimen' => [fhir_specimen_complete_example] } } })
      result = run(test, { reports: { a: 'a' } }) # test skips without input report
      expect(result.result).to eq('pass')
    end

    it 'fails if the input is missing Must Supports' do
      allow_any_instance_of(test).to receive(:scratch).and_return({ cpds_resources: { temp: { 'Specimen' => [fhir_specimen_incomplete_example] } } })
      result = run(test, { reports: { a: 'a' } })
      expect(result.result).to eq('fail')
    end
  end
end
