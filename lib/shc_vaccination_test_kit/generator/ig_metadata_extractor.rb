# frozen_string_literal: true

require_relative 'ig_metadata'
require_relative 'group_metadata_extractor'

module SHCVaccinationTestKit
  class Generator
    class IGMetadataExtractor
      attr_accessor :ig_resources, :metadata

      def initialize(ig_resources)
        self.ig_resources = ig_resources
        self.metadata = IGMetadata.new
      end

      def extract
        add_metadata_from_ig
        add_metadata_from_resources
        metadata
      end

      def add_metadata_from_ig
        metadata.ig_version = "v#{ig_resources.ig.version}"
      end

      def resources_in_capability_statement
        ig_resources.capability_statement.rest.first.resource
      end

      def resources_in_structure_definitions
        ig_resources.resources_by_type['StructureDefinition'].map
      end

      def remove_version_from_supported_profiles
        resources_in_capability_statement.each do |resource|
          resource.supportedProfile.map! { |profile_url| profile_url.split('|').first }
        end
      end

      def add_metadata_from_resources
        metadata.groups =
          resources_in_structure_definitions.flat_map do |resource|
            supported_profile = resource.url
            GroupMetadataExtractor.new(resource, supported_profile, metadata, ig_resources).group_metadata
          end.compact
      end
    end
  end
end
