require_relative '../../../must_support_test'
require_relative '../../../generator/group_metadata'

module SHCVaccinationTestKit
  module V100
    class ShcCovid19LaboratoryResultObservationAdMustSupportTest < Inferno::Test
      include SHCVaccinationTestKit::MustSupportTest

      title 'All must support elements are provided in the Shc Covid19 Laboratory Result Observation Ad resources returned'
      description %(
        SHC Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the SHC Server Capability
        Statement. This test will look through the Observation resources
        found previously for the following must support elements:

        * Observation.code
        * Observation.component:specimen-supervision-status
        * Observation.effective[x]
        * Observation.meta
        * Observation.meta.security
        * Observation.performer
        * Observation.performer.display
        * Observation.referenceRange
        * Observation.status
        * Observation.subject
        * Observation.value[x]
      )

      id :v100_shc_covid19_laboratory_result_observation_ad_must_support_test

      def resource_type
        'Observation'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:shc_covid19_laboratory_result_observation_ad_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
