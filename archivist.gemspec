# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "archivist"
  s.version     = "1.1.0.beta1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tyler Pickett"]
  s.email       = ["t.pickett66@gmail.com"]
  s.homepage    = "http://github.com/tpickett66/archivist"
  s.summary     = "A rails 3 model archiving system based on acts_as_archive"
  s.description = %Q{This is a functional replacement for acts_as_archive in
                      rails 3 applications, the only functionality that is not
                      duplicated is the migration from acts_as_paranoid}
  s.add_dependency("activerecord",">=3.0.0")

  %w{minitest ruby-debug rake shoulda appraisal mysql2 pg}.each do |g|
    s.add_development_dependency(g)
  end
 
  s.files        = `git ls-files`.split(/\n/)
  s.require_path = 'lib'
end
