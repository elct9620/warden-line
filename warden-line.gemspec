# frozen_string_literal: true

require_relative 'lib/warden/line/version'

Gem::Specification.new do |spec|
  spec.name          = 'warden-line'
  spec.version       = Warden::Line::VERSION
  spec.authors       = ['蒼時弦也']
  spec.email         = ['contact@aotoki.dev']

  spec.summary       = 'The warden strategies for LINE ID Token'
  spec.description   = 'The warden strategies for LINE ID Token'
  spec.homepage      = 'https://github.com/elct9620/warden-line'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/elct9620/warden-line'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'warden', '~> 1.0'
end
