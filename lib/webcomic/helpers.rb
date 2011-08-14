module Webcomic
  module Helpers
    
    def current_comic
      (@comic || last_comic)
    end
    
    def first_comic
      data.webcomic.last
    end

    def last_comic
      data.webcomic.first
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
      "/#{settings.webcomic_uri}/#{comic.slug}"
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
    
  end
end