# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name     = "archivist"
  s.version  = "0.0.1alpha"
  s.platform = Gem::Platform::RUBY
  s.authors     = ["Tyler Pickett"]
  s.email       = ["t.pickett66@gmail.com"]
  s.homepage    = "http://github.com/tpickett66/archivist"
  s.summary     = "A rails 3 model archiving system based on acts_as_archive"
  s.description = ""
  s.add_dependancy("activerecord","~>3.0.1")
  s.add_development_dependency("thoughtbot-shoulda")
 
  s.files        = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md ROADMAP.md)
  s.require_path = 'lib'
end