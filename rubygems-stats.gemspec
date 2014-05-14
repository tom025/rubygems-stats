Gem::Specification.new do |s|
  s.name        = 'rubygems-stats'
  s.version     = '0.0.1'
  s.authors     = ["Tom Brand"]
  s.description = 'Generate statistics from rubygems.org'
  s.summary     = "rubygems-stats-#{s.version}"
  s.email       = 'tom025@me.com'
  s.homepage    = "https://github.com/tom025/rubygems-stats"
  s.platform    = Gem::Platform::RUBY
  s.license     = "MIT"
  s.required_ruby_version = ">= 2.1.2"

  s.add_dependency 'gems', '~> 0.8.3'
  s.add_dependency 'virtus', '~> 1.0.2'

  s.add_development_dependency 'rspec', '~> 2.14.1'
  s.add_development_dependency 'webmock', '~> 1.17.4'
  s.add_development_dependency 'vcr', '~> 2.9.0'
  s.add_development_dependency 'unindent'
  s.add_development_dependency 'pry'

  s.rubygems_version = ">= 1.6.1"
  s.files            = `git ls-files`.split("\n").reject {|path| path =~ /\.gitignore$/ }
  s.test_files       = `git ls-files -- spec/*`.split("\n")
  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_path     = "lib"
end
