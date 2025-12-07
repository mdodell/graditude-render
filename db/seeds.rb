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

puts "\n📚 Seeding programs..."

# Create programs for each organization
programs_data = [
  # Programs for Computer Science Society
  {
    organization: organizations[0],
    name: "Web Development Bootcamp",
    description: "A 12-week intensive program teaching modern web development with React, Node.js, and databases.",
    created_by_user: owner_user
  },
  {
    organization: organizations[0],
    name: "Machine Learning Workshop Series",
    description: "Weekly workshops covering fundamentals of machine learning and AI applications.",
    created_by_user: admin_user
  },
  {
    organization: organizations[0],
    name: "Competitive Programming Team",
    description: "Training program for students interested in competitive programming and coding competitions.",
    created_by_user: developer_user
  },
  # Programs for Engineering Innovation Hub
  {
    organization: organizations[1],
    name: "Robotics Lab Access Program",
    description: "Hands-on robotics development program with access to lab equipment and mentorship.",
    created_by_user: owner_user
  },
  {
    organization: organizations[1],
    name: "Sustainable Engineering Initiative",
    description: "Program focused on developing sustainable engineering solutions for environmental challenges.",
    created_by_user: admin_user
  },
  # Programs for Business Analytics Club
  {
    organization: organizations[2],
    name: "Data Analytics Certificate",
    description: "Professional certificate program in business data analytics and visualization.",
    created_by_user: owner_user
  },
  {
    organization: organizations[2],
    name: "Industry Case Study Workshop",
    description: "Monthly workshops analyzing real-world business cases using data analytics.",
    created_by_user: admin_user
  },
  # Programs for Research Collaboration Network
  {
    organization: organizations[3],
    name: "Interdisciplinary Research Grant",
    description: "Funding program supporting collaborative research across multiple departments.",
    created_by_user: owner_user
  },
  {
    organization: organizations[3],
    name: "Graduate Research Symposium",
    description: "Annual symposium program for graduate students to present their research findings.",
    created_by_user: developer_user
  },
  # Programs for Alumni Mentorship Program
  {
    organization: organizations[4],
    name: "Career Mentorship Track",
    description: "One-on-one mentorship program pairing students with alumni in their field of interest.",
    created_by_user: owner_user
  },
  {
    organization: organizations[4],
    name: "Entrepreneurship Mentorship",
    description: "Specialized mentorship program for students interested in starting their own businesses.",
    created_by_user: admin_user
  }
]

programs = []
programs_data.each do |program_data|
  program = Program.find_or_create_by!(
    name: program_data[:name],
    organization: program_data[:organization]
  ) do |p|
    p.description = program_data[:description]
    p.created_by_user = program_data[:created_by_user]
  end

  programs << program
  puts "✅ Program created: #{program.name} in #{program.organization.name}"
end

# Add some additional members to organizations
puts "\n👥 Adding additional organization members..."

# Get some sample users to add to organizations
sample_users = [
  admin_user,
  developer_user,
  test_user,
  User.find_by(email: 'john.doe@example.com'),
  User.find_by(email: 'jane.smith@example.com'),
  User.find_by(email: 'sarah.jones@example.com')
].compact

# Add 2-4 random users to each organization as members
organizations.each do |org|
  # Skip the owner (already added during org creation)
  available_users = sample_users.reject { |u| u.has_any_role?(resource: org) }

  # Add 2-4 random users to this organization
  users_to_add = available_users.sample(rand(2..4))

  users_to_add.each do |user|
    org.memberships.find_or_create_by!(user: user)
    user.add_role(:member, org)
    puts "✅ Added #{user.email} as member to #{org.name}"
  end
end

# Now add program members from organization members
puts "\n👥 Adding program members..."

organizations.each do |org|
  # Get all users who are members of this organization
  org_members = org.users.to_a

  # For each program in this organization
  org.programs.each do |program|
    # Skip the program owner (already added during program creation)
    available_members = org_members.reject { |u| u.has_any_role?(resource: program) }

    next if available_members.empty?

    # Add 1-3 random organization members to each program
    members_to_add = available_members.sample(rand(1..3))

    members_to_add.each do |member|
      # Randomly assign as member or admin (80% member, 20% admin)
      role = rand < 0.8 ? :member : :admin

      program.memberships.find_or_create_by!(user: member)
      member.add_role(role, program)
      puts "✅ Added #{member.email} as #{role} to #{program.name}"
    end
  end
end

puts "\n🎉 Seeding completed!"
puts "Total users created: #{User.count}"
puts "Verified users: #{User.where(verified: true).count}"
puts "Unverified users: #{User.where(verified: false).count}"
puts "Total colleges: #{College.count}" if defined?(College)
puts "Total organizations: #{Organization.count}"
puts "Total programs: #{Program.count}"

# Display login credentials for easy access
puts "\n🔑 Login Credentials for Testing:"
puts "Owner: owner@graditude.com / owner123456789"
puts "Admin: admin@graditude.com / admin123456789"
puts "Developer: developer@graditude.com / dev123456789"
puts "Test: test@graditude.com / test123456789"
puts "Sample: john.doe@example.com / john123456789"
puts "Unverified: pending@graditude.com / password123456"
