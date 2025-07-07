require_relative 'shc_covid19_laboratory_result_observation_ad/shc_covid19_laboratory_result_observation_ad_must_support_test'
require_relative 'shc_covid19_laboratory_result_observation_ad/shc_covid19_laboratory_result_observation_ad_validation_test'

module SHCVaccinationTestKit
  module V100
    class ShcCovid19LaboratoryResultObservationAdGroup < Inferno::TestGroup
      title 'Observation COVID-19 Laboratory Result - Allowable Data Tests'
      short_description 'Verify support for the server capabilities required by the COVID-19 Laboratory Result Observation Profile - Allowable Data.'
      description %(
  # Background

The SHC Observation COVID-19 Laboratory Result - Allowable Data sequence verifies that the system under test is
able to provide correct responses for Observation queries. These queries
must contain resources conforming to the COVID-19 Laboratory Result Observation Profile - Allowable Data as
specified in the SHC v1.0.0 Implementation Guide.

# Testing Methodology
## Searching
This test sequence will first perform each required search associated
with this resource. This sequence will perform searches with the
following parameters:


### Search Parameters
The first search uses the selected patient(s) from the prior launch
sequence. Any subsequent searches will look for its parameter values
from the results of the first search. For example, the `identifier`
search in the patient sequence is performed by looking for an existing
`Patient.identifier` from any of the resources returned in the `_id`
search. If a value cannot be found this way, the search is skipped.

### Search Validation
Inferno will retrieve up to the first 20 bundle pages of the reply for
Observation resources and save them for subsequent tests. Each of
these resources is then checked to see if it matches the searched
parameters in accordance with [FHIR search
guidelines](https://www.hl7.org/fhir/search.html). The test will fail,
for example, if a Patient search for `gender=male` returns a `female`
patient.


## Must Support
Each profile contains elements marked as "must support". This test
sequence expects to see each of these elements at least once. If at
least one cannot be found, the test will fail. The test will look
through the Observation resources found in the first test for these
elements.

## Profile Validation
Each resource returned from the first search is expected to conform to
the [COVID-19 Laboratory Result Observation Profile - Allowable Data](http://hl7.org/fhir/uv/shc-vaccination/StructureDefinition/shc-covid19-laboratory-result-observation-ad). Each element is checked against
teminology binding and cardinality requirements.

Elements with a required binding are validated against their bound
ValueSet. If the code/system in the element is not part of the ValueSet,
then the test will fail.

## Reference Validation
At least one instance of each external reference in elements marked as
"must support" within the resources provided by the system must resolve.
The test will attempt to read each reference found and will fail if no
read succeeds.

      )

      id :v100_shc_covid19_laboratory_result_observation_ad
      run_as_group

      def self.metadata
        @metadata ||= Generator::GroupMetadata.new(YAML.load_file(File.join(__dir__, 'shc_covid19_laboratory_result_observation_ad', 'metadata.yml'), aliases: true))
      end
      
        test from: :v100_shc_covid19_laboratory_result_observation_ad_must_support_test
        test from: :v100_shc_covid19_laboratory_result_observation_ad_validation_test
    end
  end
end
