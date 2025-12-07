# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🧹 Cleaning up data..."

# Clean up in order to respect foreign key constraints
# 1. Organizations (cascades to memberships, join tables)
# 2. Users (cascades to sessions, roles via rolify)
# Keep colleges - they're reference data

Organization.destroy_all
puts "✅ Cleared all organizations and related data"

# Clean up users - this will also clean up sessions and roles
User.destroy_all
puts "✅ Cleared all users and related data"

puts "\n🌱 Seeding user accounts..."

# Create dedicated admin and owner users
admin_user = User.find_or_create_by!(email: 'admin@graditude.com') do |user|
  user.password = 'admin123456789'
  user.verified = true
end
puts "✅ Admin user created: #{admin_user.email}"

owner_user = User.find_or_create_by!(email: 'owner@graditude.com') do |user|
  user.password = 'owner123456789'
  user.verified = true
end
puts "✅ Owner user created: #{owner_user.email}"

# Create developer/test users
developer_user = User.find_or_create_by!(email: 'developer@graditude.com') do |user|
  user.password = 'dev123456789'
  user.verified = true
end
puts "✅ Developer user created: #{developer_user.email}"

test_user = User.find_or_create_by!(email: 'test@graditude.com') do |user|
  user.password = 'test123456789'
  user.verified = true
end
puts "✅ Test user created: #{test_user.email}"

# Create sample users for demonstration
sample_users = [
  {
    email: 'john.doe@example.com',
    password: 'john123456789',
    verified: true
  },
  {
    email: 'jane.smith@example.com',
    password: 'jane123456789',
    verified: true
  },
  {
    email: 'mike.wilson@example.com',
    password: 'mike123456789',
    verified: false
  },
  {
    email: 'sarah.jones@example.com',
    password: 'sarah123456789',
    verified: true
  },
  {
    email: 'david.brown@example.com',
    password: 'david123456789',
    verified: false
  }
]

sample_users.each do |user_attrs|
  user = User.find_or_create_by!(email: user_attrs[:email]) do |user|
    user.password = user_attrs[:password]
    user.verified = user_attrs[:verified]
  end
  puts "✅ Sample user created: #{user.email} (#{user.verified ? 'verified' : 'unverified'})"
end

# Create some users with different verification statuses for testing
unverified_users = [
  'pending@graditude.com',
  'newuser@example.com',
  'signup@test.com'
]

unverified_users.each do |email|
  user = User.find_or_create_by!(email: email) do |user|
    user.password = 'password123456'
    user.verified = false
  end
  puts "✅ Unverified user created: #{user.email}"
end

# Create sample users specifically for invitations (these users exist but haven't been invited yet)
invited_sample_users = [
  {
    email: 'alex.martinez@example.com',
    password: 'alex123456789',
    verified: true
  },
  {
    email: 'emily.chen@example.com',
    password: 'emily123456789',
    verified: true
  },
  {
    email: 'ryan.thompson@example.com',
    password: 'ryan123456789',
    verified: true
  },
  {
    email: 'sophia.kim@example.com',
    password: 'sophia123456789',
    verified: false
  },
  {
    email: 'michael.rodriguez@example.com',
    password: 'michael123456789',
    verified: true
  }
]

invited_sample_users.each do |user_attrs|
  user = User.find_or_create_by!(email: user_attrs[:email]) do |user|
    user.password = user_attrs[:password]
    user.verified = user_attrs[:verified]
  end

  # Ensure password and verification status are correct for testing (always update)
  user.update!(password: user_attrs[:password], verified: user_attrs[:verified])

  puts "✅ Invited sample user created: #{user.email} (#{user.verified ? 'verified' : 'unverified'})"
end

# Seed colleges from CSV if file exists
colleges_csv_path = Rails.root.join('db', 'seeds', 'csv', 'us_universities.csv')
if File.exist?(colleges_csv_path)
  puts "\n🏫 Seeding colleges from CSV..."
  Rake::Task['db:seed:colleges'].invoke
else
  puts "\n⚠️  No colleges CSV found at #{colleges_csv_path}"
  puts "   To seed colleges, place a 'colleges.csv' file in db/seeds/csv/"
  puts "   Then run: bin/rails db:seed:colleges"
end

puts "\n🏢 Seeding organizations..."

# Create sample colleges for organizations
puts "Creating sample colleges..."
colleges = College.limit(5)

# Create sample organizations
organizations_data = [
  {
    name: "Computer Science Society",
    domain: "cs-society.stanford.edu",
    description: "A community for computer science students and professionals to collaborate and learn together.",
    colleges: [ colleges[0] ]
  },
  {
    name: "Engineering Innovation Hub",
    domain: "eng-hub.mit.edu",
    description: "Fostering innovation and collaboration among engineering students and alumni.",
    colleges: [ colleges[1] ]
  },
  {
    name: "Business Analytics Club",
    domain: "biz-analytics.harvard.edu",
    description: "Connecting business students interested in data analytics and business intelligence.",
    colleges: [ colleges[2] ]
  },
  {
    name: "Research Collaboration Network",
    domain: "research-net.berkeley.edu",
    description: "Facilitating interdisciplinary research collaborations across departments.",
    colleges: [ colleges[3] ]
  },
  {
    name: "Alumni Mentorship Program",
    domain: "mentorship.yale.edu",
    description: "Connecting current students with alumni for mentorship and career guidance.",
    colleges: [ colleges[4] ]
  }
]

organizations = []
organizations_data.each do |org_data|
  org = Organization.find_or_create_by!(domain: org_data[:domain]) do |o|
    o.name = org_data[:name]
    o.description = org_data[:description]
    o.created_by_user = owner_user
  end

  # Associate colleges
  org.colleges = org_data[:colleges] unless org.colleges.any?

  organizations << org
  puts "✅ Organization created: #{org.name} (#{org.domain})"
end



puts "\n🎉 Seeding completed!"
puts "Total users created: #{User.count}"
puts "Verified users: #{User.where(verified: true).count}"
puts "Unverified users: #{User.where(verified: false).count}"
puts "Total colleges: #{College.count}" if defined?(College)
puts "Total organizations: #{Organization.count}"

# Display login credentials for easy access
puts "\n🔑 Login Credentials for Testing:"
puts "Owner: owner@graditude.com / owner123456789"
puts "Admin: admin@graditude.com / admin123456789"
puts "Developer: developer@graditude.com / dev123456789"
puts "Test: test@graditude.com / test123456789"
puts "Sample: john.doe@example.com / john123456789"
puts "Unverified: pending@graditude.com / password123456"
