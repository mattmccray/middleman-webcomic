$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "webcomic/version"
 
desc "builds gem"
task :build do
  system "gem build webcomic-middleman.gemspec"
end
 
desc "releases gem"
task :release => :build do
  system "gem push webcomic-middleman-#{Webcomic::VERSION}.gem"
end

desc "installs gem"
task :install => :build do
  system "gem install webcomic-middleman-#{Webcomic::VERSION}"
end

desc "uninstalls gem"
task :uninstall do
  system "gem uninstall webcomic-middleman"
end
