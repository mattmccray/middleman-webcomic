require 'thor'
require 'date'

class String
  def create_slug
    s= self.downcase.gsub(/'/, '').gsub(/[^a-z0-9]+/, '-')
    s.chop! if s[-1] == '-'
    s
  end
end

module Middleman
  
  module Webcomic

    def self.load_from(path, app)
      all= []
      Dir["#{path}/*.comic*"].each do |filename| # Hardcoded for markdown... For now
        comic = Comic.new(filename, app)
        #puts comic.pub_date.inspect
        all << comic if comic.publishable?
      end

      all.sort! {|x,y| y.pub_date <=> x.pub_date }
    
      # Update all the position info...
      cl= all.length
      all.each_with_index do |comic, i|
        comic[:position]= (cl - i)
        comic[:index]= i
        comic.first= all[-1]
        comic.last= all[0]
        comic.next= i > 0  ? all[i - 1] :  nil
        comic.prev= i < (cl - 1) ? all[i + 1] : nil
        if app.settings.webcomic_enable_stories and comic.story 
          Story.find_or_create_for comic
        end
      end
    
      stories= Story.all
      stories.sort! {|x,y| y.pub_date <=> x.pub_date }
      sl= stories.length
      stories.each_with_index do |story, i|
        story.position= (sl - i)
        # puts "##{story.position} - #{story.title}(#{story.slug}): #{story.comics.length}"
      end
    
      [all, stories]
    end
  
    class Story
      attr_accessor :title, :slug, :comics, :position
    
      def initialize(title)
        @title= title
        @slug= @title.create_slug
        @comics= []
        @position= nil
      end
    
      def pub_date
        @comics.last.pub_date
      end
    
      def add_comic(comic)
        @comics << comic
      end
    
      class << self
      
        def all
          @stories ||= {}
          @stories.values
        end
      
        def find_or_create_for(comic)
          title= comic.story
          @stories ||= {}
          unless @stories.has_key? title
            story= @stories[title]= new(title)
          end
          @stories[title].add_comic comic
          @stories[title]
        end
      end
    end

    class Comic
  
      attr_accessor :content, :source, :metadata, :path, :next, :prev, :first, :last
  
      def initialize(path, app)
        @app= app
        settings= app.settings
        @path= path
        @source= ""
        @content= ""
        @next= nil
        @prev= nil
        @first= nil
        @last= nil
        @metadata= ::Thor::CoreExt::HashWithIndifferentAccess.new({})
        @metadata[:ext]= File.extname(path)
        @metadata[:publish_date]= Date.today #Time.now.strftime "%Y-%m-%d"
        @metadata[:slug]= File.basename(path).gsub( @metadata[:ext], '').gsub('.comic','')
      
        if /^([\d]{2})([\d]{2})([\d]{2})\-(.*)(\.comic#{@metadata[:ext]})$/ =~ File.basename(path)
          year= "20#{ $1 }"
          month= $2
          day= $3
          @metadata[:publish_date]= Date.parse "#{year}-#{month}-#{day}"
          @metadata[:slug]= $4
        end
      
        @metadata[:title]= @metadata[:slug].titleize rescue @metadata[:slug]
        @metadata[:slug]= @metadata[:slug].downcase
      
        # Parse yaml header...
        begin
          read_yaml()
        rescue
          puts "Error reading YAML! #{self.slug}"
        end
      
        if self.filename.nil?
          throw "Filename Missing: Comics must define a filename! (#{self.slug})"
        end

        if publishable?
          # Dont' waste time if it's not a publishable comic
          engine= Tilt[path].new { @source }
          @content= engine.render
        end
      end
    
      def [](key)
        @metadata[key]
      end
      def []=(key, value)
        #puts "Setting #{key} to #{value}"
        @metadata[key]= value
      end
    
      def method_missing(key, value=nil)
        if @metadata.has_key? key
          @metadata[key]
        elsif @metadata.has_key? key.to_s
          @metadata[key.to_s]
        else
          #super Should it throw an error?
          nil
        end
      end
    
      def to_json *a
        data= @metadata.reject {|k,v| k == :ext or k == "ext" }
        data.to_json *a
      end
    
      def publishable?
        @is_publishable ||= begin
          now= Time.now
          now_string = now.strftime "%Y-%m-%d"
          today= Date.parse(now_string)
          pubdate= self.pub_date
          case pubdate
          when String
            self['publish_date']= Date.parse(pubdate)
            pubdate <= now_string
          when Time
            self['publish_date']= Date.parse(pubdate.strftime('%Y-%m-%d'))
            pubdate <= now
          when Date
            pubdate <= today
          else
            true
          end
        end
      end
  
      def pub_date
        date= self.publish_on || self.publish_date || self.date
        case date
        when String
          Date.parse(date)
        when Time
          Date.parse(date.strftime('%Y-%m-%d'))
        when Date
          date
        else
          Date.today
        end
      end
    
    private
  
      def read_yaml()
        @raw = File.read(@path)
        data, source= @app.parse_front_matter @raw
        data.each_pair do |k,v|
          @metadata[k]= v
        end
        @source= source
      end
  
    end
  end
end