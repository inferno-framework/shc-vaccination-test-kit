require_relative '../../lib/shc_vaccination_test_kit/shc_vaccination_validation_test.rb'

RSpec.describe SHCVaccinationTestKit::SHCVaccinationFHIRValidation do
  let(:suite) { Inferno::Repositories::TestSuites.new.find('shc_vaccination') }
  let(:session_data_repo) { Inferno::Repositories::SessionData.new }
  let(:runner) { Inferno::TestRunner.new(test_session: test_session, test_run: test_run) }
  let(:test_session) do
    Inferno::Repositories::TestSessions.new.create(test_suite_id: suite.id)
  end
  let(:request_repo) { Inferno::Repositories::Requests.new }
  let(:group) { suite.groups.first }

  def run(runnable, inputs = {})
    test_run_params = { test_session_id: test_session.id }.merge(runnable.reference_hash)
    test_run = Inferno::Repositories::TestRuns.new.create(test_run_params)
    inputs.each do |name, value|
      session_data_repo.save(test_session_id: test_session.id, name: name, value: value, type: 'text')
    end
    Inferno::TestRunner.new(test_session: test_session, test_run: test_run).run(runnable)
  end

  describe 'health_card_fhir_validation_test' do

    let(:test) { group.tests.find { |t| t.id.include?('shc_vaccination_validation_test')} }
    let(:url) { 'http://example.com/hc' }
    let(:operation_outcome_success) do
      {
        outcomes: [{
          issues: []
        }],
        sessionId: 'b8cf5547-1dc7-4714-a797-dc2347b93fe2'
      }
    end

    before do
      stub_request(:post, "https://example.com/validatorapi/validate")
        .to_return(status: 200, body: operation_outcome_success.to_json)
    end

    #TODO: update text with specific bundle type
    it 'passes if the JWS payload conforms to the FHIR Bundle profile' do
      credential_strings = 'eyJ6aXAiOiJERUYiLCJhbGciOiJFUzI1NiIsImtpZCI6IjRIVWIyYXJ2aFRTWHNzRW9NczJHNVRvRHBzWXZzajdoNXdUXzN6TkV0dWcifQ.hVLLjtQwEPyX5pqHk5nMI0fggoQAwcIFzcFxOhMjx45sJ2JY5d9pJ7tktLuz5BLZrq6uqu57kM5BCa33fZmmygiuWuN8uWGMQQS6aqDM9hu22xd5nkUwCijvwV96hPLnXOaoznXc-ha58m0iuK3dm-UQhwPR3MYJM8o6O76KkV03aPmHe2k0nCIQFmvUXnL1bah-ofBBUtNK-wOtC5gStglLMiINt28HXStcZYMwSlFVQEZARPZCXohhUOq7VQSw6MxgBZYhgsdDINC8wwXLO6moDD5y62aesxxRh0y-ctEiNYDTRForSWbecx_6ZsddFrMszo9XtHeLpi_kjqTANEUvKsmeKHGe-8HNZrpeoccQ88iFkBrfmXrGCFNLfZ71uovz2K2DbtU-MfachnxSJ-tUjL-JQMyVkLMDTKcpgv5BFZFZbNCiDt2v8yGQEWKw81PweSe7hSLfxhkju0SrjP80dBXaEEK-2Ra7_fMEPlxP-VYM-a0YGqm5-ufgVe_KSC2C-9VwwYrtId4vpt26VLdNY9OEFRpf8pwV8yzUME-CV4r-xNH7_whz2nRYJ1I3JnUkYJ3Hjm0OBWPHReCT4D5XDu34mNvp2fvD_k_0_QU.-jNkrXCHlq75fLCGvD8_7eF4iQ-XYQT7uZyiZ1Fqa33-ZQA1-aVEk519JZYGMDdJpO-mVqIC20Xh9sBsD8COzg'
      result = run(test, { file_download_url: url, url: url, credential_strings: credential_strings})
      binding.pry
      expect(result.result).to eq('pass')
    end
  end

  describe 'temp' do
    it 'asdfsdf' do
      credential_strings = 'eyJ6aXAiOiJERUYiLCJhbGciOiJFUzI1NiIsImtpZCI6IjRIVWIyYXJ2aFRTWHNzRW9NczJHNVRvRHBzWXZzajdoNXdUXzN6TkV0dWcifQ.hVLLjtQwEPyX5pqHk5nMI0fggoQAwcIFzcFxOhMjx45sJ2JY5d9pJ7tktLuz5BLZrq6uqu57kM5BCa33fZmmygiuWuN8uWGMQQS6aqDM9hu22xd5nkUwCijvwV96hPLnXOaoznXc-ha58m0iuK3dm-UQhwPR3MYJM8o6O76KkV03aPmHe2k0nCIQFmvUXnL1bah-ofBBUtNK-wOtC5gStglLMiINt28HXStcZYMwSlFVQEZARPZCXohhUOq7VQSw6MxgBZYhgsdDINC8wwXLO6moDD5y62aesxxRh0y-ctEiNYDTRForSWbecx_6ZsddFrMszo9XtHeLpi_kjqTANEUvKsmeKHGe-8HNZrpeoccQ88iFkBrfmXrGCFNLfZ71uovz2K2DbtU-MfachnxSJ-tUjL-JQMyVkLMDTKcpgv5BFZFZbNCiDt2v8yGQEWKw81PweSe7hSLfxhkju0SrjP80dBXaEEK-2Ra7_fMEPlxP-VYM-a0YGqm5-ufgVe_KSC2C-9VwwYrtId4vpt26VLdNY9OEFRpf8pwV8yzUME-CV4r-xNH7_whz2nRYJ1I3JnUkYJ3Hjm0OBWPHReCT4D5XDu34mNvp2fvD_k_0_QU.-jNkrXCHlq75fLCGvD8_7eF4iQ-XYQT7uZyiZ1Fqa33-ZQA1-aVEk519JZYGMDdJpO-mVqIC20Xh9sBsD8COzg'
      result = run(test, { file_download_url: url, url: url, credential_strings: credential_strings })
      expect(result.result).to eq('pass')
    end
  end

  


  # describe 'validate_fhir_bundle_test' do
  #   let(:subject) { SHCVaccinationTestKit::SHCVaccinationFHIRValidation.new }

  #   let(:vaccination_bundle) do
  #     FHIR::Bundle.new(
  #       resourceType: 'Bundle',
  #       type: 'collection',
  #       entry: [
  #         {
  #           fullUrl: 'resource:0',
  #           resource: FHIR::Patient.new(
  #             resourceType: 'Patient',
  #             name: [
  #               {
  #                 family: 'Anyperson',
  #                 given: ['Jane', 'C.']
  #               }
  #             ],
  #             birthDate: '1961-01-20'
  #           )
  #         },
  #         {
  #           fullUrl: 'resource:1',
  #           resource: FHIR::Immunization.new(
  #             resourceType: 'Immunization',
  #             meta: {
  #               security: [
  #                 {
  #                   system: 'https://smarthealth.cards/ial',
  #                   code: 'IAL2'
  #                 }
  #               ]
  #             },
  #             status: 'completed',
  #             vaccineCode: {
  #               coding: [
  #                 {
  #                   system: 'http://hl7.org/fhir/sid/cvx',
  #                   code: '206'
  #                 }
  #               ]
  #             },
  #             patient: {
  #               reference: 'resource:0'
  #             },
  #             occurrenceDateTime: '2022-08-01',
  #             lotNumber: '0000002',
  #             performer: [
  #               {
  #                 actor: {
  #                   display: 'ABC General Hospital'
  #                 }
  #               }
  #             ]
  #           )
  #         },
  #         {
  #           fullUrl: 'resource:2',
  #           resource: FHIR::Immunization.new(
  #             resourceType: 'Immunization',
  #             meta: {
  #               security: [
  #                 {
  #                   system: 'https://smarthealth.cards/ial',
  #                   code: 'IAL2'
  #                 }
  #               ]
  #             },
  #             status: 'completed',
  #             vaccineCode: {
  #               coding: [
  #                 {
  #                   system: 'http://hl7.org/fhir/sid/cvx',
  #                   code: '206'
  #                 }
  #               ]
  #             },
  #             patient: {
  #               reference: 'resource:0'
  #             },
  #             occurrenceDateTime: '2022-08-29',
  #             lotNumber: '0000003',
  #             performer: [
  #               {
  #                 actor: {
  #                   display: 'ABC General Hospital'
  #                 }
  #               }
  #             ]
  #           )
  #         }
  #       ]
  #     )
  #   end    

  #   let(:labs_bundle) do
  #     FHIR::Bundle.new(
  #       resourceType: 'Bundle',
  #       type: 'collection',
  #       entry: [
  #         {
  #           fullUrl: 'resource:0',
  #           resource: FHIR::Patient.new(
  #             resourceType: 'Patient',
  #             name: [
  #               {
  #                 family: 'Anyperson',
  #                 given: ['James', 'T.']
  #               }
  #             ],
  #             birthDate: '1951-01-20'
  #           )
  #         },
  #         {
  #           fullUrl: 'resource:1',
  #           resource: FHIR::Observation.new(
  #             resourceType: 'Observation',
  #             meta: {
  #               security: [
  #                 {
  #                   system: 'https://smarthealth.cards/ial',
  #                   code: 'IAL2'
  #                 }
  #               ]
  #             },
  #             status: 'final',
  #             code: {
  #               coding: [
  #                 {
  #                   system: 'http://loinc.org',
  #                   code: '94558-4'
  #                 }
  #               ]
  #             },
  #             subject: {
  #               reference: 'resource:0'
  #             },
  #             effectiveDateTime: '2021-02-17',
  #             performer: [
  #               {
  #                 display: 'ABC General Hospital'
  #               }
  #             ],
  #             valueCodeableConcept: {
  #               coding: [
  #                 {
  #                   system: 'http://snomed.info/sct',
  #                   code: '260373001'
  #                 }
  #               ]
  #             }
  #           )
  #         }
  #       ]
  #     )
  #   end
    
  #   it 'passes if input is a valid vaccination bundle' do
  #     expect{subject.validate_fhir_bundle(vaccination_bundle)}.not_to raise_error()
  #   end

  #   it 'passes if input is a valid labs bundle' do
  #     expect{subject.validate_fhir_bundle(labs_bundle)}.not_to raise_error()
  #   end

  #   #TODO: test that an invalid input will fail for all all bundle types

  # end

end
