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

      #begin new code FI-3622

      #TODO: what if bundle has an Immunization and an Observation?

      assert bundle.type == "collection", "bundle.type shall be collection"
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
      patient_entry_counter = 0
      immunization_entry_counter = 0
      bundle.entry.each do |vaccination_bundle_entry|
        if vaccination_bundle_entry.resource.is_a?(FHIR::Patient)
          assert_valid_resource(
            resource: vaccination_bundle_entry.resource,
            profile_url: 'http://hl7.org/fhir/uv/shc-vaccination/StructureDefinition/shc-patient-us-ad'
          )
          patient_entry_counter += 1
          scratch[:shc_patient_us_ad_resources] ||= {}
          scratch[:shc_patient_us_ad_resources][:all] ||= []
          scratch[:shc_patient_us_ad_resources][:all] << vaccination_bundle_entry.resource
        else
          #for a vaccination bundle, if the entry is not a Patient, then it must be an Immunization
          assert vaccination_bundle_entry.resource.is_a?(FHIR::Immunization),
            "#{vaccination_bundle_entry.resource.class} resource is not allowed in an Immunization Bundle"

          assert_valid_resource(
            resource: vaccination_bundle_entry.resource,
            profile_url: 'http://hl7.org/fhir/uv/shc-vaccination/StructureDefinition/shc-vaccination-ad'
          )
          immunization_entry_counter += 1
          scratch[:immunization_resources] ||= {}
          scratch[:immunization_resources][:all] ||= []
          scratch[:immunization_resources][:all] << vaccination_bundle_entry.resource
        end
      end
      assert patient_entry_counter == 1, "Expected vaccination bundle to have exactly 1 patient but found #{patient_entry_counter}"
      assert immunization_entry_counter > 0, "Expected vaccination bundle to have at least 1 immunization but found #{immunization_entry_counter}"
      scratch[:shc_vaccination_bundle_ad_resources] ||= {}
      scratch[:shc_vaccination_bundle_ad_resources][:all] ||= []
      scratch[:shc_vaccination_bundle_ad_resources][:all] << bundle
    end

    def validate_labs_bundle(bundle)
      patient_entry_counter = 0
      lab_result_entry_counter = 0
      bundle.entry.each do |vaccination_bundle_entry|
        if vaccination_bundle_entry.resource.is_a?(FHIR::Patient)
          assert_valid_resource(
            resource: vaccination_bundle_entry.resource,
            profile_url: 'http://hl7.org/fhir/uv/shc-vaccination/StructureDefinition/shc-patient-us-ad'
          )
          patient_entry_counter += 1
          scratch[:shc_patient_us_ad_resources] ||= {}
          scratch[:shc_patient_us_ad_resources][:all] ||= []
          scratch[:shc_patient_us_ad_resources][:all] << vaccination_bundle_entry.resource
        else
          #for a labs bundle, if the entry is not a Patient, then it must be a lab result (Observation)
          assert vaccination_bundle_entry.resource.is_a?(FHIR::Observation)
          assert_valid_resource(
            resource: vaccination_bundle_entry.resource,
            profile_url: 'http://hl7.org/fhir/uv/shc-vaccination/StructureDefinition/shc-infectious-disease-laboratory-result-observation-ad'
          )
          lab_result_entry_counter += 1
          scratch[:shc_infectious_disease_laboratory_result_observation_ad_resources] ||= {}
          scratch[:shc_infectious_disease_laboratory_result_observation_ad_resources][:all] ||= []
          scratch[:shc_infectious_disease_laboratory_result_observation_ad_resources][:all] << vaccination_bundle_entry.resource
        end
      end
      assert patient_entry_counter == 1
      assert lab_result_entry_counter > 0
      scratch[:shc_infectious_disease_laboratory_bundle_ad_resources] ||= {}
      scratch[:shc_infectious_disease_laboratory_bundle_ad_resources][:all] ||= []
      scratch[:shc_infectious_disease_laboratory_bundle_ad_resources][:all] << bundle
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
