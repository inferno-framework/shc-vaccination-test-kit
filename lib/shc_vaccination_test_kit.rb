require 'health_cards'
require_relative 'covid19_vci/file_download'
require_relative 'covid19_vci/fhir_operation'

module Covid19VCI
  class Suite < Inferno::TestSuite
    id 'c19-vci'
    title 'SMART Health Cards: Vaccination & Testing'

    group from: :vci_file_download
    group from: :vci_fhir_operation
  end
end
