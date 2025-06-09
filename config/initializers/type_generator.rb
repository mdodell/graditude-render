require 'rake'
require 'listen'

if Rails.env.development?
  Rails.application.config.after_initialize do
    listener = Listen.to('app/serializers') do |modified, added, removed|
      if modified.any? || added.any? || removed.any?
        puts "Detected changes in serializers, regenerating types..."
        system("script/generate_and_format_types.rb")
      end
    end

    listener.start
    puts "Type generator watcher started..."
  end
end 