# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "archivist"
  s.version     = "1.0.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tyler Pickett"]
  s.email       = ["t.pickett66@gmail.com"]
  s.homepage    = "http://github.com/tpickett66/archivist"
  s.summary     = "A rails 3 model archiving system based on acts_as_archive"
  s.description = %Q{This is a functional replacement for acts_as_archive in
                      rails 3 applications, the only functionality that is not
                      duplicated is the migration from acts_as_paranoid}
  s.add_dependancy("activerecord","~>3.0.1")
  s.add_development_dependency("thoughtbot-shoulda")
 
  s.files        = Dir.glob("{bin,lib}/**/*") + %w(MIT-LICENSE README.md)
  s.require_path = 'lib'
end
