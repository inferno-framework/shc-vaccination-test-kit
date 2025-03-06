require 'inferno/dsl/oauth_credentials'
require_relative '../../version'

require_relative 'shc_covid19_laboratory_bundle_ad_group'
require_relative 'shc_covid19_laboratory_result_observation_ad_group'
require_relative 'shc_patient_us_ad_group'
require_relative 'shc_infectious_disease_laboratory_result_observation_ad_group'
require_relative 'immunization_group'
require_relative 'shc_infectious_disease_laboratory_bundle_ad_group'
require_relative 'shc_vaccination_bundle_ad_group'

module SHCVaccinationTestKit
  module V100
    class SHCSuite < Inferno::TestSuite
      title 'v1.0.0'
      description %(
        The SHC Test Kit tests systems for their conformance to the [SHC
        Implementation Guide]().

        HL7® FHIR® resources are validated with the Java validator using
        `tx.fhir.org` as the terminology server. Users should note that the
        although the ONC Certification (g)(10) Standardized API Test Suite
        includes tests from this suite, [it uses a different method to perform
        terminology
        validation](https://github.com/onc-healthit/onc-certification-g10-test-kit/wiki/FAQ#q-why-do-some-resources-fail-in-us-core-test-kit-with-terminology-validation-errors).
        As a result, resource validation results may not be consistent between
        the SHC Test Suite and the ONC Certification (g)(10) Standardized
        API Test Suite.
      )
      version VERSION

      GENERAL_MESSAGE_FILTERS = [
        %r{Sub-extension url 'introspect' is not defined by the Extension http://fhir-registry\.smarthealthit\.org/StructureDefinition/oauth-uris},
        %r{Sub-extension url 'revoke' is not defined by the Extension http://fhir-registry\.smarthealthit\.org/StructureDefinition/oauth-uris},
        /Observation\.effective\.ofType\(Period\): .*vs-1:/, # Invalid invariant in FHIR v4.0.1
        /Observation\.effective\.ofType\(Period\): .*us-core-1:/, # Invalid invariant in SHC v3.1.1
        /Provenance.agent\[\d*\]: Constraint failed: provenance-1/, #Invalid invariant in SHC v5.0.1
        %r{Unknown Code System 'http://hl7.org/fhir/us/core/CodeSystem/us-core-tags'}, # Validator has an issue with this SHC 5 code system in SHC 6 resource
        %r{URL value 'http://hl7.org/fhir/us/core/CodeSystem/us-core-tags' does not resolve}, # Validator has an issue with this SHC 5 code system in SHC 6 resource
        /\A\S+: \S+: URL value '.*' does not resolve/,
        %r{Observation.component\[\d+\].value.ofType\(Quantity\): The code provided \(http://unitsofmeasure.org#L/min\) was not found in the value set 'Vital Signs Units'} # Known issue with the Pulse Oximetry Profile
      ].freeze
      VALIDATION_MESSAGE_FILTERS = GENERAL_MESSAGE_FILTERS

      def self.metadata
        @metadata ||= YAML.load_file(File.join(__dir__, 'metadata.yml'), aliases: true)[:groups].map do |raw_metadata|
            Generator::GroupMetadata.new(raw_metadata)
          end
      end

      id :v100

      fhir_resource_validator do
        igs '#1.0.0'
        message_filters = VALIDATION_MESSAGE_FILTERS

        exclude_message do |message|

          message_filters.any? { |filter| filter.match? message.message }
        end

        perform_additional_validation do |resource, profile_url|
          ProvenanceValidator.validate(resource) if resource.instance_of?(FHIR::Provenance)
        end
      end

      input :url,
        title: 'FHIR Endpoint',
        description: 'URL of the FHIR endpoint'

      group do
        input :smart_credentials,
          title: 'OAuth Credentials',
          type: :oauth_credentials,
          optional: true

        fhir_client do
          url :url
          oauth_credentials :smart_credentials
        end

        title 'SHC FHIR API'
        id :v100_fhir_api

      
        group from: :v100_shc_covid19_laboratory_bundle_ad
        group from: :v100_shc_covid19_laboratory_result_observation_ad
        group from: :v100_shc_patient_us_ad
        group from: :v100_shc_infectious_disease_laboratory_result_observation_ad
        group from: :v100_immunization
        group from: :v100_shc_infectious_disease_laboratory_bundle_ad
        group from: :v100_shc_vaccination_bundle_ad
      end
    end
  end
end
