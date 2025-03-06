# frozen_string_literal: true

require_relative 'special_cases'
require 'pry'
module SHCVaccinationTestKit
  class Generator
    class IGMetadata
      attr_accessor :ig_version, :groups

      def reformatted_version
        @reformatted_version ||= ig_version.delete('.').gsub('-', '_')
      end

      def ordered_groups
        @ordered_groups ||= groups
      end

      def to_hash
        {
          ig_version: ig_version,
          groups: groups.map(&:to_hash)
        }
      end
    end
  end
end
