namespace :db do
  namespace :seed do
    desc "Import colleges from CSV file"
    task :colleges, [ :filename ] => :environment do |_task, args|
      filename = args[:filename] || "us_universities.csv"
      csv_path = Rails.root.join("db", "seeds", "csv", filename)

      unless File.exist?(csv_path)
        puts "❌ CSV file not found: #{csv_path}"
        puts "Please place your colleges CSV file in: db/seeds/csv/"
        exit 1
      end

      puts "🌱 Importing colleges from #{filename}..."

      require "csv"

      imported_count = 0
      skipped_count = 0
      error_count = 0

        CSV.foreach(csv_path, headers: true, encoding: "UTF-8") do |row|
          begin
            # Map CSV columns to College attributes
            # This CSV has: name, url
            college_attrs = {
              name: row["name"] || row["college_name"] || row["institution_name"],
              website: row["url"] || row["website"] || row["web_site"]
            }

            # Skip rows with missing required data (only name is required)
            if college_attrs[:name].blank?
              puts "⚠️  Skipping row with missing name: #{row.to_h}"
              skipped_count += 1
              next
            end

            # Find or create the college
            college = College.find_or_create_by(name: college_attrs[:name]) do |c|
              c.website = college_attrs[:website]
            end

            if college.persisted?
              if college.previously_new_record?
                imported_count += 1
                puts "✅ Created: #{college.name}"
              else
                puts "⏭️  Already exists: #{college.name}"
              end
            else
              puts "❌ Failed to create: #{college.name} - #{college.errors.full_messages.join(', ')}"
              error_count += 1
            end

        rescue => e
          puts "❌ Error processing row: #{e.message}"
          puts "Row data: #{row.to_h}"
          error_count += 1
        end
      end

      puts "\n🎉 College import completed!"
      puts "✅ Imported: #{imported_count} colleges"
      puts "⏭️  Skipped: #{skipped_count} rows"
      puts "❌ Errors: #{error_count} rows"
      puts "📊 Total colleges in database: #{College.count}"
    end
  end
end
