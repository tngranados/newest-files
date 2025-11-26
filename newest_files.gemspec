# frozen_string_literal: true

require_relative 'lib/newest_files/version'

Gem::Specification.new do |spec|
  spec.name = 'newest_files'
  spec.version = NewestFiles::VERSION
  spec.authors = ['Toni Granados']
  spec.email = ['toni@tngranados.com']

  spec.summary = 'List the N most-recently-created files in a Git repository'
  spec.description = 'A CLI tool to find the newest files in a Git repository based on their ' \
                     'first commit date. Useful for discovering recent patterns and conventions ' \
                     'in large codebases.'
  spec.homepage = 'https://github.com/tngranados/newest-files'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem
  spec.files = Dir.glob(%w[
                          lib/**/*
                          exe/*
                          LICENSE.txt
                          README.md
                          CHANGELOG.md
                        ]).reject { |f| File.directory?(f) }
  spec.bindir = 'exe'
  spec.executables = ['newest-files']
  spec.require_paths = ['lib']

  # Runtime dependencies
  spec.add_dependency 'thor', '~> 1.3'

  # Development dependencies
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rubocop', '~> 1.21'
end
