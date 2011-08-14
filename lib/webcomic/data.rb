require 'active_support/core_ext/hash'

module Webcomic

  def self.load_from(path, app)
    all= []
    Dir["#{path}/*.comic*"].each do |filename| # Hardcoded for markdown... For now
      comic = Comic.new(filename, app)
      all << comic if comic.publishable?
    end

    all.sort! {|x,y| y.publish_date <=> x.publish_date }
    
    # Update all the position info...
    cl= all.length
    all.each_with_index do |comic, i|
      comic[:position]= (cl - i)
      comic[:index]= i
      comic.first= all[-1]
      comic.last= all[0]
      comic.next= i > 0  ? all[i - 1] :  nil
      comic.prev= i < (cl - 1) ? all[i + 1] : nil
    end
    
    all
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
      @metadata= ::HashWithIndifferentAccess.new    
      @metadata[:ext]= File.extname(path)
      @metadata[:publish_date]= Time.now.strftime "%Y-%m-%d"
      @metadata[:slug]= File.basename(path).gsub( @metadata[:ext], '').gsub('.comic','')
      
      if /^([\d]{2})([\d]{2})([\d]{2})\-(.*)(\.comic#{@metadata[:ext]})$/ =~ File.basename(path)
        year= "20#{ $1 }"
        month= $2
        day= $3
        @metadata[:publish_date]= "#{year}-#{month}-#{day}"
        @metadata[:slug]= $4
      end
      
      @metadata[:title]= @metadata[:slug].titleize
      @metadata[:slug]= @metadata[:slug].downcase
      
      # Parse yaml header...
      read_yaml()

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
        case self.publish_date
        when String
          self.publish_date <= now_string
        when Time
          self.publish_date <= now
        when Date
          self.publish_date <= today
        else
          true
        end
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