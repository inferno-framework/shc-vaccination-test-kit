# frozen_string_literal: true

require 'fhir_models'
require 'inferno/ext/fhir_models'

require_relative 'generator/ig_loader'
require_relative 'generator/ig_metadata_extractor'
require_relative 'generator/group_generator'
require_relative 'generator/must_support_test_generator'
require_relative 'generator/validation_test_generator'
require_relative 'generator/suite_generator'
require_relative 'generator/special_cases'

module SHCVaccinationTestKit
  class Generator
    def self.generate
      ig_packages = Dir.glob(File.join(Dir.pwd, 'lib', 'shc_vaccination_test_kit', 'igs', '*.tgz'))

      ig_packages.each do |ig_package|
        new(ig_package).generate
      end
    end

    attr_accessor :ig_resources, :ig_metadata, :ig_file_name

    def initialize(ig_file_name)
      self.ig_file_name = ig_file_name
    end

    def generate
      puts "Generating tests for IG #{File.basename(ig_file_name)}"
      load_ig_package
      extract_metadata
      generate_must_support_tests
      generate_validation_tests
      generate_groups
      generate_suites

      write_metadata
    end

    def extract_metadata
      self.ig_metadata = IGMetadataExtractor.new(ig_resources).extract

      FileUtils.mkdir_p(base_output_dir)
    end

    def write_metadata
      File.write(File.join(base_output_dir, 'metadata.yml'), YAML.dump(ig_metadata.to_hash))
    end

    def base_output_dir
      File.join(__dir__, 'generated', ig_metadata.ig_version)
    end

    def load_ig_package
      FHIR.logger = Logger.new(File::NULL)
      self.ig_resources = IGLoader.new(ig_file_name).load
    end

    def generate_validation_tests
      ValidationTestGenerator.generate(ig_metadata, base_output_dir)
    end

    def generate_must_support_tests
      MustSupportTestGenerator.generate(ig_metadata, base_output_dir)
    end

    def generate_groups
      GroupGenerator.generate(ig_metadata, base_output_dir)
    end

    def generate_suites
      SuiteGenerator.generate(ig_metadata, base_output_dir)
    end
  end
end
