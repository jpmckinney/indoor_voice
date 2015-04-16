# -*- encoding: utf-8 -*-
require File.expand_path('../lib/indoor_voice/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "indoor_voice"
  s.version     = IndoorVoice::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["James McKinney"]
  s.homepage    = "https://github.com/jpmckinney/indoor_voice"
  s.summary     = %q{Lowercase all-caps strings excluding acronyms}
  s.license     = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency('unicode_utils', '~> 1.4.0')

  s.add_development_dependency('coveralls')
  s.add_development_dependency('rake')
  s.add_development_dependency('rspec', '~> 3.1')
end
