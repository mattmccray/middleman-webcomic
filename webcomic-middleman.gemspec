lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'webcomic/version'

Gem::Specification.new do |s|
   s.name = %q{webcomic-middleman}
   s.version = Webcomic::VERSION
   s.platform = Gem::Platform::RUBY
   s.rubyforge_project = 'webcomic-middleman'
   s.has_rdoc = false
   s.date = Time.now.strftime "%Y-%m-%d"

   s.authors = ["Matt McCray"]
   s.email = %q{matt@inkwellian.com}
   s.summary = %q{A MiddleMan extension for generating webcomic sites.}
   s.homepage = %q{https://github.com/darthapo/webcomic-middleman}
   s.description = %q{Use MiddleMan to create your webcomic site with this extension.}

   s.files         = `git ls-files`.split("\n")
   s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
   s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
   s.require_paths = ["lib"]
   
   s.add_dependency 'middleman'
   s.add_dependency 'tilt'
   s.add_dependency 'thor'
   
end
