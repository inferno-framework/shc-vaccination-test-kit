# frozen_string_literal: true

module SHCVaccinationTestKit
  class Generator
    module SpecialCases
      class << self
        # def move_ms_and_validation(ig_metadata)
        #   ms_group_metadata = SHCVaccinationTestKit::Generator::GroupMetadata.new({name: "must_support", class_name: "MustSupportSequence", resource: "MustSupport", reformatted_version: "v100", version: "v1.0.0", title: 'Must Support'})
        #   validation_group_metadata = SHCVaccinationTestKit::Generator::GroupMetadata.new({name: "must_support", class_name: "MustSupportSequence", resource: "Validation", reformatted_version: "v100", version: "v1.0.0", title: 'Validation'})
        #   ig_metadata.groups.each do |group|
        #     tests_to_delete = []
        #     group.tests.each do |test|
        #       if test[:id].include?('must_support')
        #         ms_group_metadata.add_test(id: test[:id], file_name: test[:file_name])
        #         tests_to_delete << test
        #       elsif test[:id].include?('validation')
        #         validation_group_metadata.add_test(id: test[:id], file_name: test[:file_name])
        #         tests_to_delete << test
        #       end
        #     end
        #     tests_to_delete.each { |test| group.tests.delete(test) }
        #   end
        #   ig_metadata.groups << ms_group_metadata
        #   ig_metadata.groups << validation_group_metadata
        # end
      end
    end
  end
end
