begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  task default: :spec
rescue LoadError # rubocop:disable Lint/SuppressedException
end

namespace :db do
  desc 'Apply changes to the database'
  task :migrate do
    require 'inferno/config/application'
    require 'inferno/utils/migration'
    Inferno::Utils::Migration.new.run
  end
end

namespace :cpds do
  desc 'Run Generator'
  task :generate do
    require_relative 'lib/cancer_pathology_data_sharing_test_kit/generator'

    CancerPathologyDataSharingTestKit::Generator.generate
  end
end