require_relative '../generated/v1.0.0/shc_covid19_laboratory_bundle_ad/shc_covid19_laboratory_bundle_ad_must_support_test'
require_relative '../generated/v1.0.0/shc_covid19_laboratory_result_observation_ad/shc_covid19_laboratory_result_observation_ad_must_support_test'
require_relative '../generated/v1.0.0/shc_immunization_ad/shc_immunization_ad_must_support_test'
require_relative '../generated/v1.0.0/shc_infectious_disease_laboratory_bundle_ad/shc_infectious_disease_laboratory_bundle_ad_must_support_test'
require_relative '../generated/v1.0.0/shc_infectious_disease_laboratory_result_observation_ad/shc_infectious_disease_laboratory_result_observation_ad_must_support_test'
require_relative '../generated/v1.0.0/shc_patient_us_ad/shc_patient_us_ad_must_support_test'
require_relative '../generated/v1.0.0/shc_vaccination_bundle_ad/shc_vaccination_bundle_ad_must_support_test'

module SHCVaccinationTestKit
  module V100
    class ResourceMustSupportGroup < Inferno::TestGroup
      title 'Resource Must Support Tests'
      short_description 'Verifies returned resources span all Must Support elements'
      description %(
  # Background

The Must Support sequence verifies that the system under test is
able to provide resources that contain all labelled Must Support elements.

# Testing Methodology

Each profile contains elements marked as "must support". This test
sequence expects to see each of these elements at least once. If at
least one cannot be found, the test will fail. The test will look
through the CarePlan resources found in the first test for these
elements.
      )

      id :shc_must_support_group
      run_as_group

      test from: :v100_shc_covid19_laboratory_bundle_ad_must_support_test
      test from: :v100_shc_covid19_laboratory_result_observation_ad_must_support_test
      test from: :v100_shc_patient_us_ad_must_support_test
      test from: :v100_shc_infectious_disease_laboratory_result_observation_ad_must_support_test
      test from: :v100_shc_immunization_ad_must_support_test
      test from: :v100_shc_infectious_disease_laboratory_bundle_ad_must_support_test
      test from: :v100_shc_vaccination_bundle_ad_must_support_test
    end
  end
end
