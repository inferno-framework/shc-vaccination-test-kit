require_relative '../../../must_support_test'
require_relative '../../../generator/group_metadata'

module SHCVaccinationTestKit
  module V100
    class ShcInfectiousDiseaseLaboratoryBundleAdMustSupportTest < Inferno::Test
      include SHCVaccinationTestKit::MustSupportTest

      title 'All must support elements are provided in the Shc Infectious Disease Laboratory Bundle Ad resources returned'
      description %(
        SHC Responders SHALL be capable of populating all data elements as
        part of the query results as specified by the SHC Server Capability
        Statement. This test will look through the Bundle resources
        found previously for the following must support elements:

        * Bundle.entry
        * Bundle.entry.fullUrl
        * Bundle.entry.resource
        * Bundle.entry:labResult
        * Bundle.entry:labResult.fullUrl
        * Bundle.entry:patient
        * Bundle.entry:patient.fullUrl
        * Bundle.type
      )

      id :v100_shc_infectious_disease_laboratory_bundle_ad_must_support_test

      def resource_type
        'Bundle'
      end

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true))
      end

      def scratch_resources
        scratch[:shc_infectious_disease_laboratory_bundle_ad_resources] ||= {}
      end

      run do
        perform_must_support_test(all_scratch_resources)
      end
    end
  end
end
