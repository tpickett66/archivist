$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "archivist/version"

# Describe your gem and declare its dependencies:
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

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency("activerecord",">=3.0.0")

  %w{minitest pry rake shoulda appraisal mysql2}.each do |g|
    s.add_development_dependency(g)
  end
  s.add_development_dependency('rails','>=3.0.0')
end
