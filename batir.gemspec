# frozen_string_literal: true

require_relative 'lib/batir/version'

Gem::Specification.new do |spec|
  spec.authors = ['Markus Prasser', 'Vassilis Rizopoulos']
  spec.date = '2021-02-04'
  spec.description = <<desc
Batir provides code to enable project automation tasks:

 * a logging format for the build-in logger of Ruby
 * a command abstraction with a platform independent implementation for running
   shell commands and Ruby code
 * command sequences using the same command abstraction as single commands
 * a configuration format for configuration file written in Ruby
desc
  spec.email = ['markuspg@users.noreply.github.com']
  spec.files = %w( CHANGELOG.md LICENSE.txt README.md )
  spec.files += Dir.glob('lib/**/*.rb')
  spec.homepage = 'https://github.com/markuspg/batir'
  spec.license = 'MIT'
  spec.name = 'batir'
  spec.require_paths = ['lib']
  spec.required_ruby_version = Gem::Requirement.new('>= 2.5.5')
  spec.summary = 'Batir ("B"roject Automation Tools in Ruby) provides libraries' \
                 ' for use in project automation tools'
  spec.version = Batir::Version::STRING

  spec.add_development_dependency('minitest', '~> 5.14.0')
  spec.add_development_dependency('pry', '~> 0.13.0')
  spec.add_development_dependency('rake', '~> 13.0.0')
  spec.add_development_dependency('rdoc', '~> 6.3.0')
  spec.add_development_dependency('rubocop', '~> 1.9.0')
  spec.add_runtime_dependency('systemu', '~> 2.6.0')
end
