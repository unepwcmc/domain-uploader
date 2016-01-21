Gem::Specification.new do |s|
  s.name               = "domain_uploader"
  s.version            = "0.0.1"
  s.default_executable = "domain_uploader"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ferdinando Primerano"]
  s.date = %q{2015-07-12}
  s.description = %q{Upload project domain into labs}
  s.email = %q{f.primerano90@gmail.com}
  s.files = [
    "Gemfile", "Rakefile", "lib/domain_uploader.rb", "lib/tasks/uploader.rake",
    "lib/domain_generator.rb", "lib/graph_generator.rb"
  ]
  s.test_files = []
  s.homepage = %q{http://rubygems.org/gems/domain_uploader}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Domain Uploader!}

  s.add_development_dependency "rake"
  s.add_development_dependency "bundler", "~> 1.10"
  s.add_runtime_dependency "httparty", "~> 0.13"
  s.add_runtime_dependency "rails-erd"
end
