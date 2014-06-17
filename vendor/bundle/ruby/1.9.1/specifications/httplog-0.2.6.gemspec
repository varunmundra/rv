# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "httplog"
  s.version = "0.2.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Thilo Rusche"]
  s.date = "2014-02-14"
  s.description = "Log outgoing HTTP requests made from your application. Helpful for tracking API calls\n                     of third party gems that don't provide their own log output."
  s.email = "thilorusche@gmail.com"
  s.homepage = "http://github.com/trusche/httplog"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.23"
  s.summary = "Logs outgoing HTTP requests."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<rack>, [">= 0"])
      s.add_development_dependency(%q<thin>, [">= 0"])
      s.add_development_dependency(%q<httpclient>, [">= 0"])
      s.add_development_dependency(%q<httparty>, [">= 0"])
      s.add_development_dependency(%q<faraday>, [">= 0"])
      s.add_development_dependency(%q<excon>, [">= 0.18.0"])
      s.add_development_dependency(%q<typhoeus>, [">= 0"])
      s.add_development_dependency(%q<ethon>, [">= 0"])
      s.add_development_dependency(%q<patron>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rack>, [">= 0"])
      s.add_dependency(%q<thin>, [">= 0"])
      s.add_dependency(%q<httpclient>, [">= 0"])
      s.add_dependency(%q<httparty>, [">= 0"])
      s.add_dependency(%q<faraday>, [">= 0"])
      s.add_dependency(%q<excon>, [">= 0.18.0"])
      s.add_dependency(%q<typhoeus>, [">= 0"])
      s.add_dependency(%q<ethon>, [">= 0"])
      s.add_dependency(%q<patron>, [">= 0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rack>, [">= 0"])
    s.add_dependency(%q<thin>, [">= 0"])
    s.add_dependency(%q<httpclient>, [">= 0"])
    s.add_dependency(%q<httparty>, [">= 0"])
    s.add_dependency(%q<faraday>, [">= 0"])
    s.add_dependency(%q<excon>, [">= 0.18.0"])
    s.add_dependency(%q<typhoeus>, [">= 0"])
    s.add_dependency(%q<ethon>, [">= 0"])
    s.add_dependency(%q<patron>, [">= 0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
  end
end
