# coding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require 'haoyaoshi/version'

Gem::Specification.new do |spec|
  spec.name          = "haoyaoshi"
  spec.version       = Haoyaoshi::VERSION
  spec.authors       = ["guoyoujin"]
  spec.email         = ["guoyoujin123@gmail.com"]

  spec.summary       = "hao yao shi api"
  spec.description   = "hao yao shi api"
  spec.homepage      = "https://github.com/guoyoujin/haoyaoshi"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         =  Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.test_files = Dir["test/**/*"]

  spec.add_runtime_dependency "rest-client", '>= 1.7'
  spec.add_runtime_dependency "activesupport", '>= 3.2'

  spec.add_development_dependency "bundler", '~> 1'
  spec.add_development_dependency "rake", '~> 11.2'
  spec.add_development_dependency "fakeweb", '~> 1'
end
