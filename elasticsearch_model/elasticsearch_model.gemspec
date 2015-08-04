$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "elasticsearch_model/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "elasticsearch_model"
  s.version     = ElasticsearchModel::VERSION
  s.authors     = ["Fellipe Fingoli"]
  s.email       = ["fellipe.fingoli@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO:"
  s.description = "TODO: ElasticsearchModel is the model classes with de propose of modeling your Elasticsearch Schemas on Rails."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 3.2.0", "<4.2.2"
  s.add_dependency "elasticsearch"
end
