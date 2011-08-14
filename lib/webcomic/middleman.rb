require 'fileutils'

module Middleman
  module Features
    module Webcomic
      class << self

        def registered(app)
          puts "Webcomic v#{::Webcomic::VERSION}"
      
          # Default settings:
          app.set :webcomic_images, "images/comics"
          app.set :webcomic_source, "comics"
          app.set :webcomic_source_images, "comics/images"
          app.set :webcomic_source_type, :markdown
          app.set :webcomic_uri, "comics"
          app.set :webcomic_template, "/comics/template.html"
          
          # ???
          app.set :webcomic_enable_stories, false
          app.set :webcomic_enable_tags, false
          app.set :webcomic_sort_by, :publish_date # or slug? and metadata

      
          app.helpers ::Webcomic::Helpers
      
          app.after_configuration do
            comics= ::Webcomic.load_from( File.join(app.root, app.settings.webcomic_source), app )

            comics.each do |comic|
              src_path= File.join(app.root, app.settings.webcomic_source_images, comic.filename)
              tgt_path= File.join(app.views, app.settings.webcomic_images, comic.filename)
              
              unless File.exists? tgt_path
                if File.exists? src_path
                  puts "Moving into place: #{comic.filename}"
                  FileUtils.mkdir_p File.dirname(tgt_path), :verbose=>false
                  FileUtils.cp src_path, tgt_path, :verbose=>false
                else
                  puts "MISSING COMIC: #{comic.filename}"
                end
              end
              
              if File.exists? tgt_path
                app.page "/#{app.settings.webcomic_uri}/#{comic.slug}.html", :proxy=>app.settings.webcomic_template, :ignore=>true do
                  @comic= comic
                end
              else
                puts "Skipping #{comic.filename} (#{comic.slug})"
              end
            end

            app.data_content 'webcomic', comics
          end
          
          ::Webcomic::Admin.define app
        end
        alias :included :registered

      end
    end
  end
end