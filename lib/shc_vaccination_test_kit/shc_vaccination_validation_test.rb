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

      #begin new code FI-3622

      #TODO: what if bundle has an Immunization and an Observation?

      #binding.pry

      assert bundle.type == "collection", "bundle.type shall be collection"
      #binding.pry
      if bundle.entry.any? { |r| r.resource.is_a?(FHIR::Immunization) }
        #bundle is an Immunization Bundle
        validate_vaccination_bundle(bundle)
      elsif bundle.entry.any? { |r| r.resource.is_a?(FHIR::Observation) }
        #bundle is either a COVID-19 Labs Bundle or Generic Labs Bundle
        validate_labs_bundle(bundle)
      else
        assert false, "The resource is a bundle, but does not conform to any of bundle profiles defined in the shc-vaccination-ifg"
      end


    #end new code FI-3622


    end

    def validate_vaccination_bundle(bundle)
      #binding.pry
      patient_entry_counter = 0
      immunization_entry_counter = 0
      bundle.entry.each do |vaccination_bundle_entry|
        if vaccination_bundle_entry.resource.is_a?(FHIR::Patient)
          assert_valid_resource(
            resource: vaccination_bundle_entry.resource,
            profile_url: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient'
          )
          patient_entry_counter += 1
        else
          #for a vaccination bundle, if the entry is not a Patient, then it must be an Immunization
          assert vaccination_bundle_entry.resource.is_a?(FHIR::Immunization),
            "#{vaccination_bundle_entry.resource.class} resource is not allowed in an Immunization Bundle"

          assert_valid_resource(
            resource: vaccination_bundle_entry.resource,
            profile_url: 'http://hl7.org/fhir/uv/shc-vaccination/StructureDefinition/shc-vaccination-ad'
          )
          immunization_entry_counter += 1
        end
      end
      assert patient_entry_counter == 1, "Expected vaccination bundle to have exactly 1 patient but found #{patient_entry_counter}"
      assert immunization_entry_counter > 0, "Expected vaccination bundle to have at least 1 immunization but found #{immunization_entry_counter}"
    end

    def validate_labs_bundle(bundle)
      #binding.pry
      patient_entry_counter = 0
      lab_result_entry_counter = 0
      bundle.entry.each do |vaccination_bundle_entry|
        if vaccination_bundle_entry.resource.is_a?(FHIR::Patient)
          assert_valid_resource(
            resource: vaccination_bundle_entry.resource,
            profile_url: 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-patient'
          )
          patient_entry_counter += 1
        else
          #for a labs bundle, if the entry is not a Patient, then it must be a lab result (Observation)
          assert vaccination_bundle_entry.resource.is_a?(FHIR::Observation)
          assert_valid_resource(
            resource: vaccination_bundle_entry.resource,
            profile_url: 'http://hl7.org/fhir/uv/shc-vaccination/StructureDefinition/shc-vaccination-ad'
          )
          lab_result_entry_counter += 1
        end
      end
      assert patient_entry_counter == 1
      assert lab_result_entry_counter > 0
    end

    #TODO: this method was copied from smart-health-cards-test-kit. Should use the method in the ruby gem, but when I call...
    #payload = SmartHealthCardsTestKit::HealthCard.payload_from_jws(jws)
    #it cannot find the method
    def payload_from_jws(jws)
      return nil unless jws.present?

      raw_payload = jws.payload
      assert raw_payload&.length&.positive?, 'No payload found'

      decompressed_payload =
        begin
          Zlib::Inflate.new(-Zlib::MAX_WBITS).inflate(raw_payload)
        rescue Zlib::DataError
          assert false, 'Payload compression error. Unable to inflate payload.'
        end

      assert decompressed_payload.length.positive?, 'Payload compression error. Unable to inflate payload.'

      payload_length = decompressed_payload.length
      raw_payload_length = raw_payload.length
      decompressed_payload_length = decompressed_payload.length

      warning do
        assert raw_payload_length <= decompressed_payload_length,
              "Payload may not be properly minified. Received a payload with length #{raw_payload_length}, " \
              "but was able to generate a payload with length #{decompressed_payload_length}"
      end

      assert_valid_json decompressed_payload, 'Payload is not valid JSON'

      JSON.parse(decompressed_payload)
    end

  end
end
