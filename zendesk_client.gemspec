# -*- encoding: utf-8 -*-
require File.expand_path("../lib/zendesk/version", __FILE__)

Gem::Specification.new do |gem|
  gem.add_development_dependency "yajl-ruby", "~> 0.8.2"
  gem.add_development_dependency "nokogiri", "~> 1.4"
  gem.add_development_dependency "rake", "~> 0.8"
  gem.add_development_dependency "fakeweb", "~> 1.3.0"
  gem.add_development_dependency "yard", "~> 0.7"
  gem.add_runtime_dependency "faraday", "~> 0.6.1"

  gem.authors = ["Dylan Clendenin"]
  gem.description = %q{A Ruby client for the Zendesk REST API}
  gem.email = ["dclendenin@zendesk.com"]
  gem.files = `git ls-files`.split("\n")
  gem.homepage = "https://github.com/zendesk/zendesk_client"
  gem.name = "zendesk_client"
  gem.require_paths = ["lib"]
  gem.required_rubygems_version = Gem::Requirement.new(">= 1.3.6")
  gem.summary = %q{A Ruby client for the Zendesk REST API}
  gem.test_files = `git ls-files -- test/*`.split("\n")
  gem.version = Zendesk::VERSION.dup
end