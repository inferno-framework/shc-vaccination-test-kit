# frozen_string_literal: true

require_relative 'naming'
require_relative 'special_cases'

module SHCVaccinationTestKit
  class Generator
    class SuiteGenerator
      class << self
        def generate(ig_metadata, base_output_dir)
          new(ig_metadata, base_output_dir).generate
        end
      end

      attr_accessor :ig_metadata, :base_output_dir

      def initialize(ig_metadata, base_output_dir)
        self.ig_metadata = ig_metadata
        self.base_output_dir = base_output_dir
      end

      def template
        @template ||= File.read(File.join(__dir__, 'templates', 'suite.rb.erb'))
      end

      def output
        @output ||= ERB.new(template).result(binding)
      end

      def base_output_file_name
        'shc_suite.rb'
      end

      def class_name
        'SHCSuite'
      end

      def module_name
        "#{ig_metadata.reformatted_version.upcase}"
      end

      def output_file_name
        File.join(base_output_dir, base_output_file_name)
      end

      def suite_id
        "#{ig_metadata.reformatted_version}"
      end

      def fhir_api_group_id
        "#{ig_metadata.reformatted_version}_fhir_api"
      end

      def title
        "#{ig_metadata.ig_version}"
      end

      def ig_identifier
        version = ig_metadata.ig_version[1..] # Remove leading 'v'
        "##{version}"
      end

      def ig_link
        Naming.ig_link(ig_metadata.ig_version)
      end

      def generate
        File.write(output_file_name, output)
      end

      def groups
        ig_metadata.ordered_groups
      end

      def group_id_list
        @group_id_list ||=
          groups.reject { |group| group.file_name.nil? }
            .map(&:id)
      end

      def group_file_list
        @group_file_list ||=
          groups.reject { |group| group.file_name.nil? }
            .map { |group| group.file_name.delete_suffix('.rb') }
      end

      def capability_statement_file_name
        "../../custom_groups/#{ig_metadata.ig_version}/capability_statement_group"
      end
    end
  end
end
