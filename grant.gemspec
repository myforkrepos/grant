# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'grant/version'
 
Gem::Specification.new do |s|
  s.name        = "grant"
  s.version     = Grant::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Jeff Kunkle", "Matt Wizeman"]
  s.homepage    = "http://github.com/nearinfinity/grant"
  s.summary     = "Conscious security constraints for your ActiveRecord model objects"
  s.description = "Grant is a Ruby gem and Rails plugin that forces you to make explicit security decisions about the operations performed on your ActiveRecord models."
  s.license     = "MIT"

  s.files         = `git ls-files`.split("\n").reject { |path| path =~ /^(Gemfile|.gitignore|Rakefile)/ }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('activerecord', '>= 4.0.0')

  s.add_development_dependency('rspec', '2.5.0')
  s.add_development_dependency('sqlite3', '1.3.9')
end
