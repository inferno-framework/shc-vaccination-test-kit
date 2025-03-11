require 'smart_health_cards_test_kit'
require_relative 'shc_vaccination_test_kit/shc_vaccination_validation_test'
require_relative 'shc_vaccination_test_kit/metadata'

module SHCVaccinationTestKit
  class SHCVaccinationSuite < Inferno::TestSuite
    id 'shc_vaccination'
    title 'SMART Health Cards: Vaccination & Testing'
    description %(
      This test suite evaluates the ability of a system to provide
      access to [SMART Health Cards Vaccination and Testing](https://hl7.org/fhir/uv/shc-vaccination/2021Sep/index.html)
      resources via file download, HL7® FHIR® API, or QR Scanning.
    )
    source_code_url('https://github.com/inferno-framework/shc-vaccination-test-kit')
    download_url('https://github.com/inferno-framework/shc-vaccination-test-kit/releases')
    report_issue_url('https://github.com/inferno-framework/shc-vaccination-test-kit/issues')

    VALIDATION_MESSAGE_FILTERS = [
      /\A\S+: \S+: URL value '.*' does not resolve/,
    ].freeze

    fhir_resource_validator do
      igs('igs/hl7.fhir.uv.smarthealthcards-vaccination-0.5.0-rc.tgz')

      exclude_message do |message|
        VALIDATION_MESSAGE_FILTERS.any? { |filter| filter.match? message.message }
      end
    end

    # Tests and TestGroups
    # SmartHealthCardsTestKit::SmartHealthCardsTestSuite.groups.each do |group|
    #   test_group = group.ancestors[1]

    #   test_group.children.reject! { |test| test.id.include?('shc_fhir_validation_test') }
    #   test_group.test(from: :shc_vaccination_validation_test)

    #   group(from: test_group.id)
    # end

    def self.add_shc_group(group_id)
      group from: group_id do
        children.reject! { |test| test.id.include?('shc_fhir_validation_test') }
        test from: :shc_vaccination_validation_test
      end
    end

    add_shc_group :shc_file_download_group
    add_shc_group :shc_fhir_operation_group
  end
end
