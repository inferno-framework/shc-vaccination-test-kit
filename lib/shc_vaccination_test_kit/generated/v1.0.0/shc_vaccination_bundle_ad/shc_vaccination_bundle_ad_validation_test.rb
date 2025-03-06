require_relative '../../../validation_test'

module SHCVaccinationTestKit
  module V100
    class ShcVaccinationBundleAdValidationTest < Inferno::Test
      include SHCVaccinationTestKit::ValidationTest

      id :v100_shc_vaccination_bundle_ad_validation_test
      title 'Bundle resources returned during previous tests conform to the Vaccination Bundle - Allowable Data profile'
      description %(
This test verifies resources returned from the first search conform to
the [Vaccination Bundle - Allowable Data](http://hl7.org/fhir/uv/shc-vaccination/StructureDefinition/shc-vaccination-bundle-ad).
Systems must demonstrate at least one valid example in order to pass this test.

It verifies the presence of mandatory elements and that elements with
required bindings contain appropriate values. CodeableConcept element
bindings will fail if none of their codings have a code/system belonging
to the bound ValueSet. Quantity, Coding, and code element bindings will
fail if their code/system are not found in the valueset.

      )
      output :dar_code_found, :dar_extension_found

      def resource_type
        'Bundle'
      end

      def scratch_resources
        scratch[:shc_vaccination_bundle_ad_resources] ||= {}
      end

      run do
        perform_validation_test(scratch_resources[:all] || [],
                                'http://hl7.org/fhir/uv/shc-vaccination/StructureDefinition/shc-vaccination-bundle-ad',
                                '1.0.0',
                                skip_if_empty: true)
      end
    end
  end
end
