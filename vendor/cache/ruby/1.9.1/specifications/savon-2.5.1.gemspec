# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "savon"
  s.version = "2.5.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Daniel Harrington"]
  s.date = "2014-05-09"
  s.description = "Heavy metal SOAP client"
  s.email = "me@rubiii.com"
  s.homepage = "http://savonrb.com"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "savon"
  s.rubygems_version = "1.8.23"
  s.summary = "Heavy metal SOAP client"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nori>, ["~> 2.4.0"])
      s.add_runtime_dependency(%q<httpi>, ["~> 2.1.0"])
      s.add_runtime_dependency(%q<wasabi>, ["~> 3.3.0"])
      s.add_runtime_dependency(%q<akami>, ["~> 1.2.0"])
      s.add_runtime_dependency(%q<gyoku>, ["~> 1.1.0"])
      s.add_runtime_dependency(%q<uuid>, ["~> 2.3.7"])
      s.add_runtime_dependency(%q<builder>, [">= 2.1.2"])
      s.add_runtime_dependency(%q<nokogiri>, [">= 1.4.0"])
      s.add_development_dependency(%q<rack>, [">= 0"])
      s.add_development_dependency(%q<puma>, ["= 2.0.0.b4"])
      s.add_development_dependency(%q<rake>, ["~> 10.1"])
      s.add_development_dependency(%q<rspec>, ["~> 2.14"])
      s.add_development_dependency(%q<mocha>, ["~> 0.14"])
      s.add_development_dependency(%q<json>, ["~> 1.7"])
    else
      s.add_dependency(%q<nori>, ["~> 2.4.0"])
      s.add_dependency(%q<httpi>, ["~> 2.1.0"])
      s.add_dependency(%q<wasabi>, ["~> 3.3.0"])
      s.add_dependency(%q<akami>, ["~> 1.2.0"])
      s.add_dependency(%q<gyoku>, ["~> 1.1.0"])
      s.add_dependency(%q<uuid>, ["~> 2.3.7"])
      s.add_dependency(%q<builder>, [">= 2.1.2"])
      s.add_dependency(%q<nokogiri>, [">= 1.4.0"])
      s.add_dependency(%q<rack>, [">= 0"])
      s.add_dependency(%q<puma>, ["= 2.0.0.b4"])
      s.add_dependency(%q<rake>, ["~> 10.1"])
      s.add_dependency(%q<rspec>, ["~> 2.14"])
      s.add_dependency(%q<mocha>, ["~> 0.14"])
      s.add_dependency(%q<json>, ["~> 1.7"])
    end
  else
    s.add_dependency(%q<nori>, ["~> 2.4.0"])
    s.add_dependency(%q<httpi>, ["~> 2.1.0"])
    s.add_dependency(%q<wasabi>, ["~> 3.3.0"])
    s.add_dependency(%q<akami>, ["~> 1.2.0"])
    s.add_dependency(%q<gyoku>, ["~> 1.1.0"])
    s.add_dependency(%q<uuid>, ["~> 2.3.7"])
    s.add_dependency(%q<builder>, [">= 2.1.2"])
    s.add_dependency(%q<nokogiri>, [">= 1.4.0"])
    s.add_dependency(%q<rack>, [">= 0"])
    s.add_dependency(%q<puma>, ["= 2.0.0.b4"])
    s.add_dependency(%q<rake>, ["~> 10.1"])
    s.add_dependency(%q<rspec>, ["~> 2.14"])
    s.add_dependency(%q<mocha>, ["~> 0.14"])
    s.add_dependency(%q<json>, ["~> 1.7"])
  end
end
