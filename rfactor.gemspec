# -*- encoding: utf-8 -*-
require 'lib/rfactor'

Gem::Specification.new do |s|
  s.name = %q{rfactor}
  s.version = Rfactor::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Fabio Kung", "Hugo Corbucci"]
  s.date = %q{2009-12-31}
  s.description = %q{Common refactorings for Ruby code, written in Ruby. This project aims  to be integrated with several editors (mainly TextMate), to provide  simple refactorings, such as:  * extract method * extract Class * extract Module * rename using ack * move using ack}
  s.email = ["fabio.kung@gmail.com", "hugo.corbucci@gmail.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc"]
  s.files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "Rakefile", "features/development.feature", "features/extract_method.feature", "features/steps/code_steps.rb", "features/steps/common.rb", "features/steps/env.rb", "lib/rfactor.rb", "lib/rfactor/code.rb", "lib/rfactor/line_finder.rb", "lib/rfactor/string_ext.rb", "script/console", "script/destroy", "script/generate", "spec/code_spec.rb", "spec/line_finder_spec.rb", "spec/rfactor_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "spec/string_ext_spec.rb", "tasks/rspec.rake"]
  s.has_rdoc = true
  s.homepage = %q{http://wiki.github.com/fabiokung/rfactor}
  s.post_install_message = %q{PostInstall.txt}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rfactor}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Common refactorings for Ruby code, written in Ruby}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<fabiokung-ruby_parser>, [">= 2.0.3"])
      s.add_development_dependency(%q<newgem>, [">= 1.1.0"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<fabiokung-ruby_parser>, [">= 2.0.3"])
      s.add_dependency(%q<newgem>, [">= 1.1.0"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<fabiokung-ruby_parser>, [">= 2.0.3"])
    s.add_dependency(%q<newgem>, [">= 1.1.0"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
