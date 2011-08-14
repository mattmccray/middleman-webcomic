# Webcomic for MiddleMan

This is how you'll setup the runtime, using bundler:

`Gemfile`

    source "http://rubygems.org"
    gem "webcomic-middleman", :git=>"git@github.com:darthapo/webcomic-middleman.git", :require=>'webcomic'


`config.rb`

    require "webcomic"

    activate :webcomic

    set :webcomic_images, "media/comics" # Or wherever...


`config.ru`

    require 'rubygems'
    require 'bundler/setup'
    require 'middleman'

    run Middleman.server