# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "devise_security_extension"
  s.version = "0.8.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Marco Scholl", "Alexander Dreher"]
  s.date = "2014-01-31"
  s.description = "An enterprise security extension for devise, trying to meet industrial standard security demands for web applications."
  s.email = "team@phatworx.de"
  s.extra_rdoc_files = ["LICENSE.txt", "README.md"]
  s.files = ["LICENSE.txt", "README.md"]
  s.homepage = "http://github.com/phatworx/devise_security_extension"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.23"
  s.summary = "Security extension for devise"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, [">= 3.1.1"])
      s.add_runtime_dependency(%q<devise>, [">= 2.0.0"])
      s.add_development_dependency(%q<rails_email_validator>, [">= 0"])
      s.add_development_dependency(%q<easy_captcha>, [">= 0"])
      s.add_development_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 2.0.1"])
    else
      s.add_dependency(%q<rails>, [">= 3.1.1"])
      s.add_dependency(%q<devise>, [">= 2.0.0"])
      s.add_dependency(%q<rails_email_validator>, [">= 0"])
      s.add_dependency(%q<easy_captcha>, [">= 0"])
      s.add_dependency(%q<bundler>, [">= 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 2.0.1"])
    end
  else
    s.add_dependency(%q<rails>, [">= 3.1.1"])
    s.add_dependency(%q<devise>, [">= 2.0.0"])
    s.add_dependency(%q<rails_email_validator>, [">= 0"])
    s.add_dependency(%q<easy_captcha>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 2.0.1"])
  end
end
