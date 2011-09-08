$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "middleman-webcomic/version"
 
desc "builds gem"
task :build do
  system "gem build middleman-webcomic.gemspec"
end
 
desc "releases gem"
task :release => :build do
  system "gem push middleman-webcomic-#{Middleman::Webcomic::VERSION}.gem"
end

desc "installs gem"
task :install => :build do
  system "gem install middleman-webcomic-#{Middleman::Webcomic::VERSION}"
end

desc "uninstalls gem"
task :uninstall do
  system "gem uninstall middleman-webcomic"
end
