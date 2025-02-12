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

    it 'passes if the JWS payload conforms to the FHIR Vaccination Bundle profile' do
      credential_strings = 'eyJ6aXAiOiJERUYiLCJhbGciOiJFUzI1NiIsImtpZCI6IjRIVWIyYXJ2aFRTWHNzRW9NczJHNVRvRHBzWXZzajdoNXdUXzN6TkV0dWcifQ.1ZPNbtswEITfZXuVLFKyY0jHJIf0EhRI2kvhA0WtLQb8MUhKiBvo3buUU8RI4h6KoEB0ozg7nPkoPYEKARroY9w3RaGdFLp3ITYVYwwysO0WGr6u6rJcsXqdwSiheYJ42CM0P-exQHPBCB97FDr2Cyl8F74cF3lakM15nXSj6nj9V40yZrDql4jKWdhkID12aKMS-m5oH1DGFGnbK_8DfUiaBpYLtuBkmt5eDrbT-BIbpNOappIyAzLyB-pCDoPW370mgcfgBi-xSQj-LJKBFQaPWmGUpjG4dVokm50a0SYkN-hb2EwUs1XU41rEdCSvV2XO6pxdnDjeH-N8o2KUAqYpezcEfxUiRBGHMPcwe40RE-FRSKksXrlu1kjXKbubo4ZDiGhe7rjX64XzuyKhKYLqCjk-koGcJ6HkDKbNlMH-ORWZedyiR5tOP0VDIifl4Oet1PNemdmClaucUd2KbLWLt4Np0ScIZbVcXazfEvh6esHnMJT_FwP_GAw858sPxVB91q-h_EcMmzeC5x96ouc3.tLGLHXF-6J-RJf-FjvR-L8I759Cberj1wk6EqGO6U7Tn87wtbexzyhE5NfUDoVav6hxKZmcDhE40_9Zu1RcVGw'
      result = run(test, { file_download_url: url, url: url, credential_strings: credential_strings})
      expect(result.result).to eq('pass')
    end

    it 'passes if the JWS payload conforms to the FHIR Labs Bundle profile' do
      credential_strings = 'eyJ6aXAiOiJERUYiLCJhbGciOiJFUzI1NiIsImtpZCI6IjRIVWIyYXJ2aFRTWHNzRW9NczJHNVRvRHBzWXZzajdoNXdUXzN6TkV0dWcifQ.hVNNj5swEP0v0ysE85EQOLZ7qSq1lbrtpcrBmCG4MnZkG9Tsiv_eMck2UbbZckGD37x57415Bukc1NB7f6iTRBnBVW-cr3PGGESgmw7qtMyrPC_ZlkUwCaifwR8PCPXPpc1Rnxu49T1y5fuV4LZ1705FHAqiuY8TZpJtWr2JkcMwavnEvTQadhEIiy1qL7n6Nja_UPggqeul_YHWBUwNxYqtUiINX9-PulV4kQ3CKEVdARkBEdkjeSGGUanvVhHAojOjFViHCF6KQKD5gCcsH6SiNvjER_-ElnB7OaEOoTxwfUSaALuZxDaS3DxwHwan1bqMWR6n2yvex5Oor2SPtMA8R_-Ukt5IcZ770S1uhoNCjyHniQshNX4w7YIRppV6vwh2R-dxuGy6V-XK2H0SAkqcbBMx_SYCsXRCxkqYd3MEh7MqIrPYoUUdpl8HRCAjxGiXo-DzUQ4niqyI0yxON0SrjP88Dg3lRCFkebHelK8T-Hi95nsxZPdi6KTm6q-DN70rI7UI7i-Gq2JdlPHZtLvcqvumsevCHZpuPK9jlsWsWHahxmUTvFH0Jo6D_48wp82A7UrqziSOBFz2sWH5ds1YdRJ4E9yXxqGdXnLbvTo__wAzPX8A.6wJmGsedX323sbFhFykRFDslJzdoTsFVXut7exz3YIFXMq2G5SeaVq2YDjRDoztryQa2BKRnK8r7y_IeXOGL_w'
      result = run(test, { file_download_url: url, url: url, credential_strings: credential_strings})
      expect(result.result).to eq('pass')
    end

    it 'fails for a JWS payload that does not conform to the FHIR Vaccination bundle or Labs Bundle profile' do
      credential_strings = 'eyJ6aXAiOiJERUYiLCJhbGciOiJFUzI1NiIsImtpZCI6IjRIVWIyYXJ2aFRTWHNzRW9NczJHNVRvRHBzWXZzajdoNXdUXzN6TkV0dWcifQ.fZBPS8QwEMW_y3htu40tlOa4CJ4EwT8X2UOaztroNFmStFCXfncnVlEEze0l7_3yZs5gQgAJQ4wnuduR04oGF6KsyrKEDGx3BCmaqr0s27quMpg1yDPE5YQgnz5igXNhVD4OqCgOhVa-DxebyJNgzN8-7WbTi_ZfjxnHyZo3FY2zcMhAe-zRRqPobupeUMdU6TgY_4g-JI-EuigLwdB0u59sT_hdG7Qj4lRyZsAgv_AsTJiIHjyxwWNwk9co0wq-RAJYNeLmVaMhjsGNvqbFJtCzmdGmpexJvSIcVm7aGR7lSsX0q2jbJhciL5sf0Put0S3PxkVgTaFfb5_1Vz7v.OGQvnvFETR68Uww__2rYP5Tk_zR9NHmD2rLf8o7wxB6UDfxlgzpK1rO5zfsdSvBEdN2L6pQWqkyqJ4ovG4i5lw'
      result = run(test, { file_download_url: url, url: url, credential_strings: credential_strings})
      expect(result.result).to eq('fail')
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
