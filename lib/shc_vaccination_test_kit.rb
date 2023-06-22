require 'health_cards'
require_relative 'covid19_vci/file_download'
require_relative 'covid19_vci/fhir_operation'

module Covid19VCI
  class Suite < Inferno::TestSuite
    id 'c19-vci'
    title 'SMART Health Cards: Vaccination & Testing'
    description %(
      This test suite evaluates the ability of a system to provide
      access to [SMART Health Cards](https://smarthealth.cards/) via file download or HL7® FHIR® API.
    )

    group from: :vci_file_download
    group from: :vci_fhir_operation
  end
end
