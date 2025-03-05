require_relative '../generated/v1.0.0/shc_covid19_laboratory_bundle_ad/shc_covid19_laboratory_bundle_ad_validation_test'
require_relative '../generated/v1.0.0/shc_covid19_laboratory_result_observation_ad/shc_covid19_laboratory_result_observation_ad_validation_test'
require_relative '../generated/v1.0.0/shc_immunization_ad/shc_immunization_ad_validation_test'
require_relative '../generated/v1.0.0/shc_infectious_disease_laboratory_bundle_ad/shc_infectious_disease_laboratory_bundle_ad_validation_test'
require_relative '../generated/v1.0.0/shc_infectious_disease_laboratory_result_observation_ad/shc_infectious_disease_laboratory_result_observation_ad_validation_test'
require_relative '../generated/v1.0.0/shc_patient_us_ad/shc_patient_us_ad_validation_test'
require_relative '../generated/v1.0.0/shc_vaccination_bundle_ad/shc_vaccination_bundle_ad_validation_test'

module SHCVaccinationTestKit
  module V100
    class ResourceValidationGroup < Inferno::TestGroup
      title 'Resource Validation Tests'
      short_description 'Validates all resources received in bundles'
      description %(
  # Background

The Resource Validation sequence verifies that the system under test is
able to provide valid resources.

# Testing Methodology

Each resource returned from the first search is expected to conform to
the [US Core CarePlan Profile](http://hl7.org/fhir/us/core/StructureDefinition/us-core-careplan). Each element is checked against
teminology binding and cardinality requirements.

Elements with a required binding are validated against their bound
ValueSet. If the code/system in the element is not part of the ValueSet,
then the test will fail.
      )

      id :shc_validation_group
      run_as_group

      test from: :v100_shc_covid19_laboratory_bundle_ad_validation_test
      test from: :v100_shc_covid19_laboratory_result_observation_ad_validation_test
      test from: :v100_shc_patient_us_ad_validation_test
      test from: :v100_shc_infectious_disease_laboratory_result_observation_ad_validation_test
      test from: :v100_shc_immunization_ad_validation_test
      test from: :v100_shc_infectious_disease_laboratory_bundle_ad_validation_test
      test from: :v100_shc_vaccination_bundle_ad_validation_test
    end
  end
end