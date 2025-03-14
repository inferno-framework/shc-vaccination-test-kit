# frozen_string_literal: true

require_relative 'lib/shc_vaccination_test_kit/version'

Gem::Specification.new do |spec|
  spec.name          = 'shc_vaccination_test_kit'
  spec.version       = SHCVaccinationTestKit::VERSION
  spec.authors       = ['Stephen MacVicar']
  spec.email         = ['vci-ig@mitre.org']
  spec.date          = Time.now.utc.strftime('%Y-%m-%d')
  spec.summary       = 'A collection of tests for the SMART Health Cards: Vaccination & Testing FHIR Implementation Guide'
  spec.description   = 'A collection of tests for the SMART Health Cards: Vaccination & Testing FHIR Implementation Guide'
  spec.homepage      = 'https://github.com/inferno-framework/shc-vaccination-test-kit'
  spec.license       = 'Apache-2.0'
  spec.add_runtime_dependency 'inferno_core', '~> 0.6.4'
  spec.add_runtime_dependency 'smart_health_cards_test_kit', '~> 0.10.1'
  spec.add_development_dependency 'database_cleaner-sequel', '~> 1.8'
  spec.add_development_dependency 'factory_bot', '~> 6.1'
  spec.add_development_dependency 'rspec', '~> 3.10'
  spec.add_development_dependency 'webmock', '~> 3.11'
  spec.required_ruby_version = Gem::Requirement.new('>= 3.3.6')
  spec.metadata['inferno_test_kit'] = 'true'
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/inferno-framework/shc-vaccination-test-kit'
  spec.files = `[ -d .git ] && git ls-files -z lib config/presets LICENSE`.split("\x0")

  spec.require_paths = ['lib']
end
