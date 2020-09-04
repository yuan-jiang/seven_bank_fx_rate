# frozen_string_literal: true

require_relative 'lib/seven_bank_fx_rate/version'

Gem::Specification.new do |spec|
  spec.name          = 'seven_bank_fx_rate'
  spec.version       = SevenBankFxRate::VERSION
  spec.authors       = ['Andy Jiang']
  spec.email         = ['yuanjiang@outlook.com']

  spec.summary       = 'Easier access to the foreign exchange rate data of Seven Bank international money transfer service in Japan.'
  spec.homepage      = 'https://github.com/yuan-jiang/seven_bank_fx_rate'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['allowed_push_host'] = 'https://rubygems.org/'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = 'https://github.com/yuan-jiang/seven_bank_fx_rate/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webmock', '~> 3.0'
end
