Gem::Specification.new do |spec|
  spec.name          = 'cancer_pathology_data_sharing_test_kit'
  spec.version       = '0.0.1'
  spec.authors       = ["Robert Passas"]
  # spec.email         = ['TODO']
  spec.date          = Time.now.utc.strftime('%Y-%m-%d')
  spec.summary       = 'Cancer Pathology Data Sharing Test Kit Test Kit'
  spec.description   = 'Cancer pathology data sharing test kit Inferno test kit for FHIR'
  # spec.homepage      = 'TODO'
  spec.license       = 'Apache-2.0'
  spec.add_runtime_dependency 'inferno_core', '~> 0.6.4'
  spec.add_development_dependency 'database_cleaner-sequel', '~> 1.8'
  spec.add_development_dependency 'factory_bot', '~> 6.1'
  spec.add_development_dependency 'rspec', '~> 3.10'
  spec.add_development_dependency 'webmock', '~> 3.11'
  spec.required_ruby_version = Gem::Requirement.new('>= 3.3.6')
  # spec.metadata['homepage_uri'] = spec.homepage
  # spec.metadata['source_code_uri'] = 'TODO'
  spec.files = [
    Dir['lib/**/*.rb'],
    Dir['lib/**/*.json'],
    'LICENSE'
  ].flatten

  spec.require_paths = ['lib']
end
