require 'inferno'

module SHCVaccinationTestKit
  class SHCVaccinationFHIRValidation < Inferno::Test
    include SmartHealthCardsTestKit::HealthCard

    id :shc_vaccination_validation_test
    title 'test Health Card payloads conform to the Vaccination Credential Bundle Profiles'
    description %(
      SMART Health Card (SHC) for vaccination records payload SHALL be a valid FHIR Bundle resource
    )
    input :credential_strings

    run do

      skip_if credential_strings.blank?, 'No Verifiable Credentials received'

      credential_strings.split(',').each do |credential|

        jws = SmartHealthCardsTestKit::Utils::JWS.from_jws(credential)
        payload = payload_from_jws(jws)

        vc = payload['vc']
        assert vc.is_a?(Hash), "Expected 'vc' claim to be a JSON object, but found #{vc.class}"

        subject = vc['credentialSubject']
        assert subject.is_a?(Hash), "Expected 'vc.credentialSubject' to be a JSON object, but found #{subject.class}"

        raw_bundle = subject['fhirBundle']
        assert raw_bundle.is_a?(Hash), "Expected 'vc.fhirBundle' to be a JSON object, but found #{raw_bundle.class}"

        bundle = FHIR::Bundle.new(raw_bundle)

        validate_fhir_bundle(bundle)
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
