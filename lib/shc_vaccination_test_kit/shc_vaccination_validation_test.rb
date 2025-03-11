require 'inferno'

module SHCVaccinationTestKit
  class SHCVaccinationFHIRValidation < Inferno::Test
    include SmartHealthCardsTestKit::HealthCard

    id :shc_vaccination_validation_test
    title 'test Health Card payloads conform to the Vaccination Credential Bundle Profiles'
    description %(
      SMART Health Card (SHC) for vaccination records payload SHALL be a valid FHIR Bundle resource
    )
    input :fhir_bundles

    run do
      skip_if fhir_bundles.blank?, 'No FHIR bundles received'

      assert_valid_json(fhir_bundles)
      bundle_array = JSON.parse(fhir_bundles)

      skip_if bundle_array.blank?, 'No FHIR bundles received'

      bundle_array.each do |bundle|
        validate_fhir_bundle(FHIR::Bundle.new(bundle))
      end
    end

    def validate_fhir_bundle(bundle)
      # assert bundle.entry.any? { |r| r.resource.is_a?(FHIR::Immunization) } || bundle.entry.any? { |r| r.resource.is_a?(FHIR::Observation) },
      # "Bundle must have either Immunization entries or Observation entries"

      # if bundle.entry.any? { |r| r.resource.is_a?(FHIR::Immunization) }
      assert_valid_resource(
        resource: bundle,
        profile_url: 'http://hl7.org/fhir/uv/smarthealthcards-vaccination/StructureDefinition/vaccination-credential-bundle'
      )

      warning do
        assert_valid_resource(
          resource: bundle,
          profile_url: 'http://hl7.org/fhir/uv/smarthealthcards-vaccination/StructureDefinition/vaccination-credential-bundle-dm'
        )
      end
      # end

      if bundle.entry.any? { |r| r.resource.is_a?(FHIR::Observation) }
        assert_valid_resource(
          resource: bundle,
          profile_url: 'http://hl7.org/fhir/uv/smarthealthcards-vaccination/StructureDefinition/covid19-laboratory-bundle'
        )

        warning do
          assert_valid_resource(
            resource: bundle,
            profile_url: 'http://hl7.org/fhir/uv/smarthealthcards-vaccination/StructureDefinition/covid19-laboratory-bundle-dm'
          )
        end
      end
    end
  end
end
