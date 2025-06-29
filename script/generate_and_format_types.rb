#!/usr/bin/env ruby
require_relative '../config/environment'

puts "Generating types from serializers..."
system("bundle exec rake types_from_serializers:generate")

puts "Formatting generated types..."
types_dir = File.expand_path("../app/frontend/types/serializers", __dir__)
if Dir.exist?(types_dir)
  system("npx prettier --write '#{types_dir}/**/*.{ts,tsx}'")
  system("npx eslint --fix '#{types_dir}/**/*.{ts,tsx}'")
else
  puts "No types directory found at #{types_dir}"
end
