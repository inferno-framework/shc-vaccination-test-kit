require_relative '../../../must_support_test'
require_relative '../../../generator/group_metadata'

module SHCVaccinationTestKit
  module V100
    class ImmunizationMustSupportTest < Inferno::Test
      include SHCVaccinationTestKit::MustSupportTest

      title 'All must support elements are provided in the Immunization resources returned'
      description %(
        SHC Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the SHC Server Capability
        Statement. This test will look through the Immunization resources
        found previously for the following must support elements:

        * Immunization.isSubpotent
        * Immunization.lotNumber
        * Immunization.meta
        * Immunization.meta.security
        * Immunization.occurrence[x]
        * Immunization.patient
        * Immunization.performer
        * Immunization.performer.actor
        * Immunization.performer.actor.display
        * Immunization.status
        * Immunization.vaccineCode
        * Immunization.vaccineCode.coding
      )

      id :v100_shc_immunization_ad_must_support_test

      def resource_type
        'Immunization'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:immunization_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
