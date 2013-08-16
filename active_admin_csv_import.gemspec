$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "active_admin_csv_import/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "active_admin_csv_import"
  s.version     = ActiveAdminCsvImport::VERSION
  s.authors     = ["Tomas Spacek"]
  s.email       = ["ts@papercloud.com.au"]
  s.homepage    = "http://www.papercloud.com.au"
  s.summary     = "Add CSV import to Active Admin"
  s.description = "CSV import for Active Admin capable of handling CSV files too large to import via direct file upload to Heroku"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.14"
  # s.add_dependency "backbone-rails", ">= 1.0.0.1"

  s.add_development_dependency "sqlite3"
end
