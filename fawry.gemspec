# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fawry/version'

Gem::Specification.new do |spec|
  spec.name          = 'fawry'
  spec.version       = Fawry::VERSION
  spec.authors       = ['Amr El Bakry']
  spec.email         = ['amrr@hey.com']

  spec.summary       = "A library to interface with Fawry's payment gateway API (charge, refund, payment status,
                        service callback)."
  spec.homepage      = 'https://github.com/amrrbakry/fawry'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.6'

  spec.metadata['homepage_uri'] = 'https://github.com/amrrbakry/fawry'
  spec.metadata['source_code_uri'] = 'https://github.com/amrrbakry/fawry'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'dry-validation', '~> 1.3', '>= 1.3.1'
  spec.add_dependency 'faraday', '~> 0.17.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'byebug', '~> 11.0', '>= 11.0.1'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'rubocop', '~> 0.76.0'
  spec.add_development_dependency 'webmock', '~> 3.7', '>= 3.7.6'
end
