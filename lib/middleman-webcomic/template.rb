module Middleman
  module Webcomic
    class Template < Middleman::Templates::Base
      def self.source_root
        File.dirname(__FILE__)
      end
  
      def build_scaffold
        template "template/config.tt", File.join(location, "config.rb")
        directory "template/source", File.join(location, "source")
    
        # empty_directory File.join(location, "source", options[:css_dir])
        # empty_directory File.join(location, "source", options[:js_dir])
        # empty_directory File.join(location, "source", options[:images_dir])

        empty_directory File.join(location, options[:webcomic_source])
        empty_directory File.join(location, options[:webcomic_source_images])
        empty_directory File.join(location, "source", options[:webcomic_images])        
      end
  
      def generate_rack
        template "template/config.ru", File.join(location, "config.ru")
      end
    end
  end
end

Middleman::Templates.register(:webcomic, Middleman::Webcomic::Template)