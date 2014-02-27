$:.push File.expand_path("../lib", __FILE__)

require "simple_cms/version"

Gem::Specification.new do |s|
  s.name        = "simple_cms"
  s.version     = Cms::VERSION
  s.authors     = ["Martin Kanerva"]
  s.email       = ["martin.kanerva@gmail.com"]
  s.summary     = "Gem for editing live website copy."
  s.description = "Edit live website copy."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.md"]

  s.add_dependency "rails", ">= 3.0.0"
  s.add_dependency "authority", ">= 2.9.0"
  s.add_dependency "sanitize", ">= 2.1.0"
end
