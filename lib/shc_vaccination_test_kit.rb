require 'smart_health_cards_test_kit'
# require_relative 'covid19_vci/file_download'
# require_relative 'covid19_vci/fhir_operation'

module SHCVaccinationTestKit
  class Suite < Inferno::TestSuite
    id 'shc_vaccination'
    title 'SMART Health Cards: Vaccination & Testing'
    description %(
      This test suite evaluates the ability of a system to provide
      access to [SMART Health Cards](https://smarthealth.cards/) via file download or HL7® FHIR® API.
    )

    VALIDATION_MESSAGE_FILTERS = [
      /\A\S+: \S+: URL value '.*' does not resolve/,
    ].freeze

    fhir_resource_validator do
      igs 'igs/hl7.fhir.uv.smarthealthcards-vaccination-0.5.0-rc.tgz'

      exclude_message do |message|
        VALIDATION_MESSAGE_FILTERS.any? { |filter| filter.match? message.message }
      end
    end

    scan_qr_code_html = File.read(File.join(__dir__, './covid19_vci/views/scan_qr_code.html'))
    scan_qr_code_html_route_handler = proc { [200, { 'Content-Type' => 'text/html' }, [scan_qr_code_html]] }
    route(:get, '/scan_qr_code', scan_qr_code_html_route_handler)

    qr_scanner = File.read(File.join(__dir__, './covid19_vci/javascript/qr-scanner.min.js'))
    qr_scanner_route_handler = proc { [200, { 'Content-Type' => 'text/javascript' }, [qr_scanner]] }
    route(:get, '/qr-scanner.min.js', qr_scanner_route_handler)

    qr_scanner_worker = File.read(File.join(__dir__, './covid19_vci/javascript/qr-scanner-worker.min.js'))
    qr_scanner_worker_route_handler = proc { [200, { 'Content-Type' => 'text/javascript' }, [qr_scanner_worker]] }
    route(:get, '/qr-scanner-worker.min.js', qr_scanner_worker_route_handler)

    js_qr = File.read(File.join(__dir__, './covid19_vci/javascript/jsQR.js'))
    js_qr_route_handler = proc { [200, { 'Content-Type' => 'text/javascript' }, [js_qr]] }
    route(:get, '/jsqr.js', js_qr_route_handler)

    upload_html = File.read(File.join(__dir__, './covid19_vci/views/upload_qr_code.html'))
    upload_html_route_handler = proc { [200, { 'Content-Type' => 'text/html' }, [upload_html]] }
    route(:get, '/upload_qr_code', upload_html_route_handler)


    # Tests and TestGroups
    group from: :shc_file_download_group
    group from: :shc_fhir_operation_group
    group from: :shc_qr_code_group
  end
end
