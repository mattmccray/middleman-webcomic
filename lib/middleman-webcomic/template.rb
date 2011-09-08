module Middleman
  module Webcomic
    class Template < Middleman::Templates::Base
      def self.source_root
        File.dirname(__FILE__)
      end
  
      def build_scaffold
        template "template/config.tt", File.join(location, "config.rb")
        template "template/Rakefile.tt", File.join(location, "Rakefile")
        template "template/Gemfile.tt", File.join(location, "Gemfile")
        directory "template/source", File.join(location, "source")
    
        # empty_directory File.join(location, "source", options[:css_dir])
        # empty_directory File.join(location, "source", options[:js_dir])
        # empty_directory File.join(location, "source", options[:images_dir])

        empty_directory File.join(location, "comics", "notes")
        empty_directory File.join(location, "comics", "images")
        empty_directory File.join(location, "source", "media", "comics")
      end
  
      def generate_rack
        template "template/config.ru", File.join(location, "config.ru")
      end
    end
  end
end

Middleman::Templates.register(:webcomic, Middleman::Webcomic::Template)