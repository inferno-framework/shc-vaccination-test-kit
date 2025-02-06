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

  describe 'validate_fhir_bundle_test' do
    let(:subject) { SHCVaccinationTestKit::SHCVaccinationFHIRValidation.new }

    let(:vaccination_bundle) do
      FHIR::Bundle.new(
        resourceType: 'Bundle',
        type: 'collection',
        entry: [
          {
            fullUrl: 'resource:0',
            resource: FHIR::Patient.new(
              resourceType: 'Patient',
              name: [
                {
                  family: 'Anyperson',
                  given: ['Jane', 'C.']
                }
              ],
              birthDate: '1961-01-20'
            )
          },
          {
            fullUrl: 'resource:1',
            resource: FHIR::Immunization.new(
              resourceType: 'Immunization',
              meta: {
                security: [
                  {
                    system: 'https://smarthealth.cards/ial',
                    code: 'IAL2'
                  }
                ]
              },
              status: 'completed',
              vaccineCode: {
                coding: [
                  {
                    system: 'http://hl7.org/fhir/sid/cvx',
                    code: '206'
                  }
                ]
              },
              patient: {
                reference: 'resource:0'
              },
              occurrenceDateTime: '2022-08-01',
              lotNumber: '0000002',
              performer: [
                {
                  actor: {
                    display: 'ABC General Hospital'
                  }
                }
              ]
            )
          },
          {
            fullUrl: 'resource:2',
            resource: FHIR::Immunization.new(
              resourceType: 'Immunization',
              meta: {
                security: [
                  {
                    system: 'https://smarthealth.cards/ial',
                    code: 'IAL2'
                  }
                ]
              },
              status: 'completed',
              vaccineCode: {
                coding: [
                  {
                    system: 'http://hl7.org/fhir/sid/cvx',
                    code: '206'
                  }
                ]
              },
              patient: {
                reference: 'resource:0'
              },
              occurrenceDateTime: '2022-08-29',
              lotNumber: '0000003',
              performer: [
                {
                  actor: {
                    display: 'ABC General Hospital'
                  }
                }
              ]
            )
          }
        ]
      )
    end    

    let(:labs_bundle) do
      FHIR::Bundle.new(
        resourceType: 'Bundle',
        type: 'collection',
        entry: [
          {
            fullUrl: 'resource:0',
            resource: FHIR::Patient.new(
              resourceType: 'Patient',
              name: [
                {
                  family: 'Anyperson',
                  given: ['James', 'T.']
                }
              ],
              birthDate: '1951-01-20'
            )
          },
          {
            fullUrl: 'resource:1',
            resource: FHIR::Observation.new(
              resourceType: 'Observation',
              meta: {
                security: [
                  {
                    system: 'https://smarthealth.cards/ial',
                    code: 'IAL2'
                  }
                ]
              },
              status: 'final',
              code: {
                coding: [
                  {
                    system: 'http://loinc.org',
                    code: '94558-4'
                  }
                ]
              },
              subject: {
                reference: 'resource:0'
              },
              effectiveDateTime: '2021-02-17',
              performer: [
                {
                  display: 'ABC General Hospital'
                }
              ],
              valueCodeableConcept: {
                coding: [
                  {
                    system: 'http://snomed.info/sct',
                    code: '260373001'
                  }
                ]
              }
            )
          }
        ]
      )
    end
    
    it 'passes if input is a valid vaccination bundle' do
      expect{subject.validate_fhir_bundle(vaccination_bundle)}.not_to raise_error()
    end

    it 'passes if input is a valid labs bundle' do
      expect{subject.validate_fhir_bundle(labs_bundle)}.not_to raise_error()
    end

    #TODO: test that an invalid input will fail for all all bundle types

  end
end