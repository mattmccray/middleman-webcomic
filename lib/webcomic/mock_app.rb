require 'middleman'
require 'slim'
require 'tilt'

module Webcomic
  class MockApp
  
    attr_reader :settings
    
    def initialize(settings={})
      @settings= ::Thor::CoreExt::HashWithIndifferentAccess.new(settings)
    end
    
    def method_missing(key, value=nil)
      if @settings.has_key? key
        @settings[key]
      elsif @settings.has_key? key.to_s
        @settings[key.to_s]
      else
        #super Should it throw an error?
        nil
      end
    end
  
    def parse_front_matter(content)
      Middleman::CoreExtensions::FrontMatter.parse_front_matter(content)
    end
  end
end