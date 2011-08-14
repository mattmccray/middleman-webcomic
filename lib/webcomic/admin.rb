# Not sure if this is gonna be used... Long term.
module Webcomic
  module Admin
    class << self
      
      def define(app)
        
        app.get '/webcomic-admin' do
          " I only exist in the preview site! ADMIN!!!"
          
          render "#{File.dirname(__FILE__)}/views/new", :layout=>false
        end
        
        
      end
      
    end
  end
end