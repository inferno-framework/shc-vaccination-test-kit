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

    let(:vaccincation_bundle) do
      FHIR::Bundle.new(
        type: 'collection'
      )
    end

    let(:covid_labs_bundle) do
      FHIR::Bundle.new(
        type: 'collection'
      )
    end

    let(:general_labs_bundle) do
      FHIR::Bundle.new(
        type: 'collection'
      )
    end

    it 'passes if input is a valid vaccination bundle' do
      expect{subject.validate_vaccination_bundle(vaccincation_bundle)}.not_to raise_error()
    end

    it 'passes if input is a valid COVID labs bundle' do
      expect{subject.validate_covid_labs_bundle(vaccincation_bundle)}.not_to raise_error()
    end

    it 'passes if input is a valid general labs bundle' do
      expect{subject.validate_general_labs_bundle(vaccincation_bundle)}.not_to raise_error()
    end

    #TODO: test that an invalid input will fail for all 3 bundle types

  end
end