require_relative '../../lib/shc_vaccination_test_kit/shc_vaccination_validation_test.rb'

RSpec.describe SHCVaccinationTestKit::SHCVaccinationFHIRValidation do
  let(:suite) { Inferno::Repositories::TestSuites.new.find('shc_vaccination') }
  let(:session_data_repo) { Inferno::Repositories::SessionData.new }
  let(:runner) { Inferno::TestRunner.new(test_session: test_session, test_run: test_run) }
  let(:test_session) do
    Inferno::Repositories::TestSessions.new.create(test_suite_id: suite.id)
  end
  let(:test_scratch) { {} }
  let(:request_repo) { Inferno::Repositories::Requests.new }
  let(:group) { suite.groups.first.groups.first }

  def run(runnable, inputs = {})
    test_run_params = { test_session_id: test_session.id }.merge(runnable.reference_hash)
    test_run = Inferno::Repositories::TestRuns.new.create(test_run_params)
    inputs.each do |name, value|
      session_data_repo.save(test_session_id: test_session.id, name: name, value: value, type: 'text')
    end
    Inferno::TestRunner.new(test_session: test_session, test_run: test_run).run(runnable)
  end

  describe 'health_card_fhir_validation_test' do

    let(:test) { group.tests.find { |t| t.id.include?('shc_vaccination-Group01-shc_file_download_group-shc_vaccination_validation_test')} }
    let(:url) { 'http://example.com/hc' }
    let(:operation_outcome_success) do
      {
        outcomes: [{
          issues: []
        }],
        sessionId: 'b8cf5547-1dc7-4714-a797-dc2347b93fe2'
      }
    end

    let(:fhir_bundle_example) do
      FHIR::Bundle.new(
          resourceType: "Bundle",
          type: "collection",
          entry: [{
            fullUrl: "resource:0",
            resource: FHIR::Patient.new(
              resourceType: "Patient",
              name: [{
                family: "Anyperson",
                given: ["James",
                "T."]
              }],
              birthDate: "1951-01-20"
            )
          },
          {
            fullUrl: "resource:1",
            resource: FHIR::Observation.new(
              resourceType: "Observation",
              meta: {
                security: [{
                  system: "https://smarthealth.cards/ial",
                  code: "IAL2"
                }]
              },
              status: "final",
              code: {
                coding: [{
                  system: "http://loinc.org",
                  code: "94558-4"
                }]
              },
              subject: {
                reference: "resource:0"
              },
              effectiveDateTime: "2021-02-17",
              performer: [{
                display: "ABC General Hospital"
              }],
              valueCodeableConcept: {
                coding: [{
                  system: "http://snomed.info/sct",
                  code: "260373001"
                }]
              }
            )
          }]
      )
    end

    let(:fhir_bundle_corrina_rowe) do
      FHIR::Bundle.new(
        type: 'collection',
        entry: [
          {
            fullUrl: 'resource:0',
            resource: FHIR::Patient.new(
              name: [
                {
                  family: 'Rowe',
                  given: ['Corrina']
                }
              ],
              birthDate: '1971-12-06',
              resourceType: 'Patient'
            )
          },
          {
            fullUrl: 'resource:1',
            resource: FHIR::Immunization.new(
              status: 'completed',
              vaccineCode: {
                coding: [
                  {
                    system: 'http://hl7.org/fhir/sid/cvx',
                    code: '207'
                  }
                ]
              },
              patient: {
                reference: 'resource:0'
              },
              occurrenceDateTime: '2025-02-05',
              lotNumber: '1234567',
              resourceType: 'Immunization'
            )
          }
        ],
        resourceType: 'Bundle'
      )
    end
    let (:fhir_bundle_deanne_gleichner) do
      FHIR::Bundle.new(
        type: 'collection',
        entry: [
          {
            fullUrl: 'resource:0',
            resource: FHIR::Patient.new(
              name: [
                {
                  family: 'Gleichner',
                  given: [
                    'Deanne'
                  ]
                }
              ],
              birthDate: '2007-04-11',
              resourceType: 'Patient'
            )
          },
          {
            fullUrl: 'resource:1',
            resource: FHIR::Immunization.new(
              status: 'completed',
              vaccineCode: {
                coding: [
                  {
                    system: 'http://hl7.org/fhir/sid/cvx',
                    code: '210'
                  }
                ]
              },
              patient: {
                reference: 'resource:0'
              },
              occurrenceDateTime: '2025-02-04',
              lotNumber: '1234567',
              resourceType: 'Immunization'
            )
          }
        ],
        resourceType: 'Bundle'
      )
    end

    let(:immunization_bundle_example) do
      FHIR::Bundle.new(
        resourceType: "Bundle",
        type: "collection",
        entry: [{
          fullUrl: "resource:0",
          resource: FHIR::Patient.new(
            resourceType: "Patient",
            name: [{
              family: "Anyperson",
              given: ["John",
              "B."]
            }],
            birthDate: "1951-01-20"
          )
        },
        {
          fullUrl: "resource:1",
          resource: FHIR::Immunization.new(
            resourceType: "Immunization",
            meta: {
              security: [{
                system: "https://smarthealth.cards/ial",
                code: "IAL1.2"
              }]
            },
            status: "completed",
            vaccineCode: {
              coding: [{
                system: "http://hl7.org/fhir/sid/cvx",
                code: "207"
              }]
            },
            patient: {
              reference: "resource:0"
            },
            occurrenceDateTime: "2021-01-01",
            lotNumber: "0000001",
            performer: [{
              actor: {
                display: "ABC General Hospital"
              }
            }]
          )
        },
        {
          fullUrl: "resource:2",
          resource: FHIR::Immunization.new(
            resourceType: "Immunization",
            meta: {
              security: [{
                system: "https://smarthealth.cards/ial",
                code: "IAL1.2"
              }]
            },
            status: "completed",
            vaccineCode: {
              coding: [{
                system: "http://hl7.org/fhir/sid/cvx",
                code: "207"
              }]
            },
            patient: {
              reference: "resource:0"
            },
            occurrenceDateTime: "2021-01-29",
            lotNumber: "0000007",
            performer: [{
              actor: {
                display: "ABC General Hospital"
              }
            }]
          )
        },
        {
          fullUrl: "resource:3",
          resource: FHIR::Immunization.new(
            resourceType: "Immunization",
            meta: {
              security: [{
                system: "https://smarthealth.cards/ial",
                code: "IAL1.2"
              }]
            },
            status: "completed",
            vaccineCode: {
              coding: [{
                system: "http://hl7.org/fhir/sid/cvx",
                code: "229"
              }]
            },
            patient: {
              reference: "resource:0"
            },
            occurrenceDateTime: "2022-09-05",
            lotNumber: "0000001",
            performer: [{
              actor: {
                display: "ABC General Hospital"
              }
            }]
          )
        }]
        )
    end

    let(:fhir_bundle_example_incorrect) do
      FHIR::Bundle.new(
          resourceType: "Bundle",
          type: "collection",
          entry: [{
            fullUrl: "resource:1",
            resource: FHIR::Observation.new(
              resourceType: "Observation",
              meta: {
                security: [{
                  system: "https://smarthealth.cards/ial",
                  code: "IAL2"
                }]
              },
              status: "final",
              code: {
                coding: [{
                  system: "http://loinc.org",
                  code: "94558-4"
                }]
              },
              subject: {
                reference: "resource:0"
              },
              effectiveDateTime: "2021-02-17",
              performer: [{
                display: "ABC General Hospital"
              }],
              valueCodeableConcept: {
                coding: [{
                  system: "http://snomed.info/sct",
                  code: "260373001"
                }]
              }
            )
          }]
      )
    end

    before do
      stub_request(:post, "https://example.com/validatorapi/validate")
        .to_return(status: 200, body: operation_outcome_success.to_json)
    end

    it 'passes if the JWS payload conforms to the FHIR Vaccination Bundle profile' do
      fhir_bundles = [ fhir_bundle_corrina_rowe ].to_json
      result = run(test, { file_download_url: url, url: url, fhir_bundles: fhir_bundles})
      expect(result.result).to eq('pass')
    end

    it 'passes if the JWS payload conforms to the FHIR Labs Bundle profile' do
      fhir_bundles = [ fhir_bundle_deanne_gleichner ].to_json
      result = run(test, { file_download_url: url, url: url, fhir_bundles: fhir_bundles})
      expect(result.result).to eq('pass')
    end

    it 'fails for a JWS payload that does not conform to the FHIR Vaccination bundle or Labs Bundle profile' do
      fhir_bundles = [ fhir_bundle_example_incorrect ].to_json
      result = run(test, { file_download_url: url, url: url, fhir_bundles: fhir_bundles})
      expect(result.result).to eq('fail')
    end

    it 'correctly organizes bundles into the proper scratch locations' do
      allow_any_instance_of(test).to receive(:scratch).and_return(test_scratch)
      fhir_bundles = [ fhir_bundle_example, immunization_bundle_example ].to_json
      result = run(test, { file_download_url: url, url: url, fhir_bundles: fhir_bundles})
      expect(result.result).to eq('pass')
      expect(test_scratch[:shc_vaccination_bundle_ad_resources][:all]).to include(immunization_bundle_example)
      expect(test_scratch[:shc_vaccination_bundle_ad_resources][:all]).not_to include(fhir_bundle_example)
      expect(test_scratch[:shc_infectious_disease_laboratory_bundle_ad_resources][:all]).to include(fhir_bundle_example)
      expect(test_scratch[:shc_infectious_disease_laboratory_bundle_ad_resources][:all]).not_to include(immunization_bundle_example)
    end

    it 'skips if the no FHIR bundles received' do
      result = run(test, { file_download_url: url, url: url, fhir_bundles: [].to_json})
      expect(result.result).to eq('skip')
    end
  end
end
