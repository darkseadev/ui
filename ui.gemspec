require_relative 'lib/ui/version'

Gem::Specification.new do |spec|
  spec.name          = 'darksea-ui'
  spec.version       = UI::VERSION
  spec.authors       = ['darksea']
  spec.email         = ['your.email@example.com']

  spec.summary       = 'UI components for Rails applications using Tailwind CSS'
  spec.description   = 'A collection of reusable UI components for Rails applications, styled with Tailwind CSS'
  spec.homepage      = 'https://github.com/your-username/ui'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.7.0')

  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/your-username/ui'
  spec.metadata['changelog_uri'] = 'https://github.com/your-username/ui/blob/main/CHANGELOG.md'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '>= 6.0.0'
  spec.add_dependency 'view_component', '>= 2.0.0'
end
