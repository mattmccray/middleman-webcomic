module Webcomic
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
    
  end
end