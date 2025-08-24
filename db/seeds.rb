# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Seeding user accounts..."

# Create admin user
admin_user = User.find_or_create_by!(email: 'admin@graditude.com') do |user|
  user.password = 'admin123456789'
  user.verified = true
end
puts "✅ Admin user created: #{admin_user.email}"

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

puts "\n🎉 Seeding completed!"
puts "Total users created: #{User.count}"
puts "Verified users: #{User.where(verified: true).count}"
puts "Unverified users: #{User.where(verified: false).count}"

# Display login credentials for easy access
puts "\n🔑 Login Credentials for Testing:"
puts "Admin: admin@graditude.com / admin123456789"
puts "Developer: developer@graditude.com / dev123456789"
puts "Test: test@graditude.com / test123456789"
puts "Sample: john.doe@example.com / john123456789"
puts "Unverified: pending@graditude.com / password123456"
