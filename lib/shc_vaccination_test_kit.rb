require 'smart_health_cards_test_kit'
require_relative 'shc_vaccination_test_kit/shc_vaccination_validation_test'

module SHCVaccinationTestKit
  class SHCVaccinationSuite < Inferno::TestSuite
    id 'shc_vaccination'
    title 'SMART Health Cards: Vaccination & Testing'
    description %(
      This test suite evaluates the ability of a system to provide
      access to [SMART Health Cards Vaccination and Testing](https://hl7.org/fhir/uv/shc-vaccination/2021Sep/index.html)
      resources via file download, HL7® FHIR® API, or QR Scanning.
    )

    VALIDATION_MESSAGE_FILTERS = [
      /\A\S+: \S+: URL value '.*' does not resolve/,
    ].freeze

    fhir_resource_validator do
      igs 'igs/hl7.fhir.uv.smarthealthcards-vaccination-1.0.0.tgz'

      exclude_message do |message|
        VALIDATION_MESSAGE_FILTERS.any? { |filter| filter.match? message.message }
      end
    end

    scan_qr_code_html = File.read(File.join(__dir__, './shc_vaccination_test_kit/views/scan_qr_code.html'))
    scan_qr_code_html_route_handler = proc { [200, { 'Content-Type' => 'text/html' }, [scan_qr_code_html]] }
    route(:get, '/scan_qr_code', scan_qr_code_html_route_handler)

    qr_scanner_route_handler = proc { [200, { 'Content-Type' => 'text/javascript' }, [qr_scanner]] }
    route(:get, '/qr-scanner.min.js', qr_scanner_route_handler)

    qr_scanner_worker = File.read(File.join(__dir__, './shc_vaccination_test_kit/javascript/qr-scanner-worker.min.js'))
    qr_scanner_worker_route_handler = proc { [200, { 'Content-Type' => 'text/javascript' }, [qr_scanner_worker]] }
    route(:get, '/qr-scanner-worker.min.js', qr_scanner_worker_route_handler)

    js_qr = File.read(File.join(__dir__, './shc_vaccination_test_kit/javascript/jsQR.js'))
    js_qr_route_handler = proc { [200, { 'Content-Type' => 'text/javascript' }, [js_qr]] }
    route(:get, '/jsqr.js', js_qr_route_handler)

    upload_html = File.read(File.join(__dir__, './shc_vaccination_test_kit/views/upload_qr_code.html'))
    upload_html_route_handler = proc { [200, { 'Content-Type' => 'text/html' }, [upload_html]] }
    route(:get, '/upload_qr_code', upload_html_route_handler)


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
    add_shc_group :shc_qr_code_group
  end
end
