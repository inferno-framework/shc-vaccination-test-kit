RSpec.describe SHCVaccinationTestKit::MustSupportTest do
  let(:suite) { Inferno::Repositories::TestSuites.new.find('shc_vaccination') }
  let(:session_data_repo) { Inferno::Repositories::SessionData.new }
  let(:runner) { Inferno::TestRunner.new(test_session: test_session, test_run: test_run) }
  let(:test_session) do
    Inferno::Repositories::TestSessions.new.create(test_suite_id: suite.id)
  end
  let(:request_repo) { Inferno::Repositories::Requests.new }
  let(:group) { suite.groups.find { |g| g.id.include?('shc_file_download_group')} }

  def run(runnable, inputs = {})
    test_run_params = { test_session_id: test_session.id }.merge(runnable.reference_hash)
    test_run = Inferno::Repositories::TestRuns.new.create(test_run_params)
    inputs.each do |name, value|
      session_data_repo.save(test_session_id: test_session.id, name: name, value: value, type: 'text')
    end
    Inferno::TestRunner.new(test_session: test_session, test_run: test_run).run(runnable)
  end

  describe 'health_card_fhir_must_support_test' do

    let(:test) { group.tests.find { |t| t.id.include?('v100_shc_covid19_laboratory_bundle_ad_must_support_test')} }
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

    let(:fhir_bundle_incomplete_example) do
      FHIR::Bundle.new(
          resourceType: "Bundle",
          type: "collection",
          entry: [{
            fullUrl: "resource:0",
            resource: FHIR::Patient
              resourceType: "Patient",
              name: [{
                family: "Anyperson",
                given: ["James",
                "T."]
              }],
              birthDate: "1951-01-20"
            }
          }]
      )
    end

    it 'passes if the input is contains all Must Supports' do
      allow_any_instance_of(test).to receive(:all_scratch_resources).and_return([fhir_bundle_example])
      binding.pry
      result = run(test, {file_download_url: 'a'}) #does not run without expected input for test
      expect(result.result).to eq('pass')
    end

    it 'skips if the input is missing Must Supports' do
      allow_any_instance_of(test).to receive(:all_scratch_resources).and_return([fhir_bundle_incomplete_example])
      result = run(test, {file_download_url: 'a'})
      expect(result.result).to eq('skip')
    end
    # it 'passes if the input is an array of multiple bundles that all conform to the FHIR Bundle profile' do
    #   fhir_bundles = []
    #   fhir_bundles.append(fhir_bundle_corrina_rowe.to_hash)
    #   fhir_bundles.append(fhir_bundle_deanne_gleichner.to_hash)
    #   result = run(test, { file_download_url: url, url: url, fhir_bundles: fhir_bundles})
    #   expect(result.result).to eq('pass')
    # end

  end
end