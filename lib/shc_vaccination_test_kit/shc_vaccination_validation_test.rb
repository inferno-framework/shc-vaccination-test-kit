module SHCVaccinationTestKit
  class SHCVaccinationFHIRValidation < Inferno::Test

    id :shc_vaccination_validation_test
    title 'test Health Card payloads conform to the Vaccination Credential Bundle Profiles'
    description %(
      SMART Health Card (SHC) for vaccination records payload SHALL be a valid FHIR Bundle resource
    )
    input :credential_strings

    run do
      skip_if credential_strings.blank?, 'No Verifiable Credentials received'

      credential_strings.split(',').each do |credential|
        raw_payload = HealthCards::JWS.from_jws(credential).payload
        assert raw_payload&.length&.positive?, 'No payload found'

        decompressed_payload =
          begin
            Zlib::Inflate.new(-Zlib::MAX_WBITS).inflate(raw_payload)
          rescue Zlib::DataError
            assert false, 'Payload compression error. Unable to inflate payload.'
          end

        assert decompressed_payload.length.positive?, 'Payload compression error. Unable to inflate payload.'

        payload_length = decompressed_payload.length
        health_card = HealthCards::COVIDHealthCard.from_jws(credential)
        health_card_length = health_card.to_json.length

        assert_valid_json decompressed_payload, 'Payload is not valid JSON'

        payload = JSON.parse(decompressed_payload)
        vc = payload['vc']
        assert vc.is_a?(Hash), "Expected 'vc' claim to be a JSON object, but found #{vc.class}"

        subject = vc['credentialSubject']
        assert subject.is_a?(Hash), "Expected 'vc.credentialSubject' to be a JSON object, but found #{subject.class}"

        raw_bundle = subject['fhirBundle']
        assert raw_bundle.is_a?(Hash), "Expected 'vc.fhirBundle' to be a JSON object, but found #{raw_bundle.class}"

        bundle = FHIR::Bundle.new(raw_bundle)

        #begin new code FI-3622
        assert bundle.type == "collection", "bundle.type shall be collection"
        if bundle.entry.any? { |r| r.resource.is_a?(FHIR::Immunization) }
          #bundle is an Immunization Bundle
          assert_valid_resource(
            resource: bundle,
            profile_url: 'http://hl7.org/fhir/uv/shc-vaccination/StructureDefinition/shc-vaccination-bundle-dm'
          )
        elsif bundle.entry.any? { |r| r.resource.is_a?(FHIR::Observation) }
          #bundle is either a COVID-19 Labs Bundle or Generic Labs Bundle

          #TODO: determin which type of bundle

          assert_valid_resource(
            resource: bundle,
            profile_url: 'http://hl7.org/fhir/uv/shc-vaccination/StructureDefinition/shc-covid19-laboratory-bundle-dm'
          )
        else 
          #error: resource is a bundle, but none of the 3 bundle types defined in the shc-vaccination-ifg
        end


        #end new code FI-3622


        
      end
    end
  end
end
