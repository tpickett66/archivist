$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "archivist/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "archivist"
  s.version     = Archivist::VERSION::STRING
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

  %w{minitest rake shoulda appraisal}.each do |g|
    s.add_development_dependency(g)
  end

  if RUBY_PLATFORM == 'java'
    s.add_development_dependency('activerecord-jdbcmysql-adapter')
  else
    s.add_development_dependency('mysql2')
  end

  if RUBY_VERSION < "1.9" || RUBY_PLATFORM == 'java'
    s.add_development_dependency('ruby-debug')
  else
    s.add_development_dependency('debugger')
  end

  s.add_development_dependency('factory_girl','<3.0')
  s.add_development_dependency('rails','>=3.0.0')
end
