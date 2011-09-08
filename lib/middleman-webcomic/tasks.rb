# Rake tasks
require 'rake'

def ask message
  print message
  STDIN.gets.chomp
end

NOTES_PATH= File.expand_path "./comics/notes" unless defined?(NOTES_PATH)
IMAGE_PATH= File.expand_path "./comics/images" unless defined?(IMAGE_PATH)

namespace :webcomic do

desc "Creates a new Comic notes entry from image"
task :create do
  
  puts 'Coming Soon!'
  
  # require 'yaml'
  # 
  # today= Time.now.strftime('%y%m%d')
  # title = ask('Title: ')
  # slug = title.empty? ? 'untitled' : title.strip.slugify
  # filename= "#{today}-#{slug}.comic.markdown"
  # path= "#{NOTES_PATH}/#{filename}"
  # 
  # 
  # article = {
  #   'title' => title, 
  #   'slug' => slug,
  #   'publish_date' => Time.now.strftime("%Y-%m-%d"),
  #   'filename' => 'FILENAME_HERE'
  # }.to_yaml
  # 
  # article << "---\n\n"
  # article << "Once upon a time...\n\n"
  # 
  # unless File.exist? path
  #   File.open(path, "w") do |file|
  #     file.write article
  #   end
  #   puts "Comic notes were created for you at #{path}."
  #   `mate #{path}`
  # else
  #   puts "I can't create the article, #{path} already exists."
  # end
end

desc "Validates that there are notes for each image"
task :validate do
  ptus "Coming Soon!"
end

end