require 'fileutils'

module Middleman
  module Features
    module Webcomic
      class << self

        def registered(app)
          puts "Webcomic v#{::Middleman::Webcomic::VERSION}"
      
          # Default settings:
          app.set :webcomic_images, "images/comics"
          app.set :webcomic_source, "comics"
          app.set :webcomic_source_images, "comics/images"
          app.set :webcomic_source_type, :markdown
          app.set :webcomic_uri, "comics"
          app.set :webcomic_template, "/comics/template.html"
          
          # ???
          app.set :webcomic_enable_stories, false
          app.set :webcomic_story_uri, "story"
          app.set :webcomic_story_template, "/comics/story_template.html"

          app.set :webcomic_enable_tags, false
          app.set :webcomic_sort_by, :publish_date # or slug? and metadata
          app.set :webcomic_slug_field, :slug

          app.helpers ::Middleman::Webcomic::Helpers
      
          app.after_configuration do
            comics, stories= ::Middleman::Webcomic.load_from( File.join(app.root, app.settings.webcomic_source), app )

            # puts comics.inspect

            comics.each do |comic|
              # puts "-> #{comic.filename} (#{comic.metadata.inspect})"
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
              
              slug_field= app.settings.webcomic_slug_field
              if File.exists? tgt_path
                app.page "/#{app.settings.webcomic_uri}/#{comic[slug_field]}.html", :proxy=>app.settings.webcomic_template, :ignore=>true do
                  @comic= comic
                end
              else
                puts "Skipping #{comic.filename} (#{comic[slug_field]})"
              end
            end
            
            if app.settings.webcomic_enable_stories
              stories.each do |story|
                app.page "/#{app.settings.webcomic_story_uri}/#{story.slug}.html", :proxy=>app.settings.webcomic_story_template, :ignore=>true do
                  @story= story
                end
              end
            end
            
            app.data_content 'webcomic', {
              :strips=>comics,
              :stories=>stories
            }
          end
          
          ::Middleman::Webcomic::Admin.define app
        end
        alias :included :registered

      end
    
      module Helpers
        def current_comic
          (@comic || last_comic)
        end

        def first_comic
          data.webcomic.strips.last
        end

        def last_comic
          data.webcomic.strips.first
        end

        def next_comic
          current_comic.next
        end

        def prev_comic
          current_comic.prev
        end

        def comic_image_url(comic)
          "/#{settings.webcomic_images}/#{comic.filename}"
        end
        alias :comic_image_for :comic_image_url

        def current_comic_image
          comic_image_for current_comic
        end
        alias :current_comic_image_url :current_comic_image

        def comic_path_url(comic)
          "/#{settings.webcomic_uri}/#{comic[settings.webcomic_slug_field]}"
        end
        alias :comic_path_for :comic_path_url

        def current_comic_path
          comic_path_for current_comic
        end

        def first_comic_path
          comic_path_for first_comic
        end

        def last_comic_path
          comic_path_for last_comic
        end

        def next_comic_path
          comic_path_for next_comic
        end

        def prev_comic_path
          comic_path_for prev_comic
        end


        # Story Helpers
        def start_story_path_for(object)
          story = if object.is_a? Story
            object
          else # it's a comic... right?
            data.webcomic.stories.detect  {|s| s.title == object.story }
          end
          comic_path_for story.comics.last
        end

        def story_path_for(object)
          story = if object.is_a? Story
            object
          else # it's a comic... right?
            data.webcomic.stories.detect  {|s| s.title == object.story }
          end
          "/#{settings.webcomic_story_uri}/#{story.slug}"
        end
        
        # Feed Helpers
        
        def feed_data
          data.webcomic.strips[0...10]
        end
        
        def feed_absolute_paths(source, path=settings.webcomic_domain)
          source.gsub( /src=(["']*)\//) do |match|
            "#{match[0...-1]}#{path}/"
          end
        end
      end
    end
  end
end