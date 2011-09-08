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
  
  require 'yaml'
  require 'date'
  Dir["#{IMAGE_PATH}/*.{jpg,jpe,jpeg,gif,png}"].each do |img_file|
    img_filename = File.basename( img_file )
    basename= img_filename.gsub( File.extname(img_filename), '' )
    note_filename = "#{basename}.comic.markdown"
    path= File.join NOTES_PATH, note_filename
    
    unless File.exists? path
      create_notes = ask("Notes for '#{img_filename}' are missing, create? [Yn] ")
      if create_notes.upcase[0] != 'N'
        meta= {
          'title' => basename,
          'slug' => basename,
          'publish_date' => Date.today,
          'filename' => img_filename
        }.to_yaml
        
        meta << "---\n\n"
        meta << "\n\n"
        
        File.open(path, "w") do |file|
          file.write meta
        end
        puts "Created #{path}"
      end
    end
  end
  
end

# desc "Validates that there are notes for each image"
# task :validate do
#   ptus "Coming Soon!"
# end

end