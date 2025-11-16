# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🧹 Cleaning up organizations and related data..."

# Clean up organizations and related data (but keep colleges)
# Destroy organizations - this will cascade delete memberships and invitations
# The Invitation model will automatically nullify foreign key references before destruction
Organization.destroy_all
puts "✅ Cleared all organizations and related data"

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
  end

  # Associate colleges
  org.colleges = org_data[:colleges] unless org.colleges.any?

  organizations << org
  puts "✅ Organization created: #{org.name} (#{org.domain})"
end

puts "\n👥 Assigning users to organizations..."

# Assign roles to users in organizations
# Clear structure: dedicated admin/owner users + sample users as members/admins
role_assignments = [
  # Organization 1: Computer Science Society
  { user: owner_user, organization: organizations[0], role: :owner },
  { user: admin_user, organization: organizations[0], role: :admin },
  { user: User.find_by(email: 'john.doe@example.com'), organization: organizations[0], role: :member },
  { user: User.find_by(email: 'jane.smith@example.com'), organization: organizations[0], role: :member },

  # Organization 2: Engineering Innovation Hub
  { user: owner_user, organization: organizations[1], role: :owner },
  { user: admin_user, organization: organizations[1], role: :admin },
  { user: User.find_by(email: 'john.doe@example.com'), organization: organizations[1], role: :member },
  { user: User.find_by(email: 'sarah.jones@example.com'), organization: organizations[1], role: :member },

  # Organization 3: Business Analytics Club
  { user: owner_user, organization: organizations[2], role: :owner },
  { user: admin_user, organization: organizations[2], role: :admin },
  { user: User.find_by(email: 'jane.smith@example.com'), organization: organizations[2], role: :member },
  { user: User.find_by(email: 'sarah.jones@example.com'), organization: organizations[2], role: :member },

  # Organization 4: Research Collaboration Network
  { user: owner_user, organization: organizations[3], role: :owner },
  { user: admin_user, organization: organizations[3], role: :admin },
  { user: User.find_by(email: 'john.doe@example.com'), organization: organizations[3], role: :member },

  # Organization 5: Alumni Mentorship Program
  { user: owner_user, organization: organizations[4], role: :owner },
  { user: admin_user, organization: organizations[4], role: :admin },
  { user: User.find_by(email: 'jane.smith@example.com'), organization: organizations[4], role: :member },
  { user: User.find_by(email: 'david.brown@example.com'), organization: organizations[4], role: :member }
]

role_assignments.each do |assignment|
  user = assignment[:user]
  organization = assignment[:organization]
  role = assignment[:role]

  next unless user && organization

  # Add rolify role
  user.add_role(role, organization) unless user.has_role?(role, organization)

  # Create membership if it doesn't exist
  membership = organization.organization_memberships.find_or_initialize_by(user: user)
  if membership.new_record?
    membership.joined_at = Time.current
    membership.save!
    puts "✅ #{user.email} assigned as #{role} to #{organization.name} (membership created)"
  else
    puts "✅ #{user.email} assigned as #{role} to #{organization.name}"
  end
end

puts "\n📧 Creating invitations..."

# Create user accounts for some invited emails so they can sign in and accept invitations
invited_users_to_create = [
  { email: 'new.cs.student@stanford.edu', password: 'newcs123456789', verified: true },
  { email: 'alumni.cs@stanford.edu', password: 'alumnics123456789', verified: true },
  { email: 'grad.student@mit.edu', password: 'gradstudent123456789', verified: true },
  { email: 'mba.student@harvard.edu', password: 'mbastudent123456789', verified: true },
  { email: 'phd.researcher@berkeley.edu', password: 'phdresearcher123456789', verified: true },
  { email: 'senior.student@yale.edu', password: 'seniorstudent123456789', verified: true }
]

invited_users_to_create.each do |user_attrs|
  user = User.find_or_create_by!(email: user_attrs[:email]) do |user|
    user.password = user_attrs[:password]
    user.verified = user_attrs[:verified]
  end

  # Ensure password and verification status are correct for testing (always update)
  user.update!(password: user_attrs[:password], verified: user_attrs[:verified])

  puts "✅ Invited user account created: #{user.email} (#{user.verified ? 'verified' : 'unverified'})"
end

# Create invitations for organizations
# Using dedicated admin/owner users for consistent invitation management
invitations_data = [
  # Organization 1 invitations
  { organization: organizations[0], email: 'new.cs.student@stanford.edu', invited_by: owner_user },
  { organization: organizations[0], email: 'alumni.cs@stanford.edu', invited_by: admin_user },
  { organization: organizations[0], email: 'professor.cs@stanford.edu', invited_by: owner_user },

  # Organization 2 invitations
  { organization: organizations[1], email: 'grad.student@mit.edu', invited_by: owner_user },
  { organization: organizations[1], email: 'research.eng@mit.edu', invited_by: admin_user },

  # Organization 3 invitations
  { organization: organizations[2], email: 'mba.student@harvard.edu', invited_by: owner_user },
  { organization: organizations[2], email: 'analytics.pro@harvard.edu', invited_by: admin_user },

  # Organization 4 invitations
  { organization: organizations[3], email: 'phd.researcher@berkeley.edu', invited_by: owner_user },
  { organization: organizations[3], email: 'postdoc@berkeley.edu', invited_by: admin_user },

  # Organization 5 invitations
  { organization: organizations[4], email: 'senior.student@yale.edu', invited_by: owner_user },
  { organization: organizations[4], email: 'recent.grad@yale.edu', invited_by: admin_user },

  # Invitations for sample users (users that exist but haven't joined yet)
  { organization: organizations[0], email: 'alex.martinez@example.com', invited_by: owner_user },
  { organization: organizations[0], email: 'emily.chen@example.com', invited_by: admin_user },

  { organization: organizations[1], email: 'ryan.thompson@example.com', invited_by: owner_user },
  { organization: organizations[1], email: 'sophia.kim@example.com', invited_by: admin_user },

  { organization: organizations[2], email: 'michael.rodriguez@example.com', invited_by: owner_user },
  { organization: organizations[2], email: 'alex.martinez@example.com', invited_by: admin_user },

  { organization: organizations[3], email: 'emily.chen@example.com', invited_by: owner_user },

  { organization: organizations[4], email: 'ryan.thompson@example.com', invited_by: owner_user }
]

invitations_data.each do |invitation_data|
  organization = invitation_data[:organization]
  email = invitation_data[:email]
  invited_by = invitation_data[:invited_by]

  next unless organization && invited_by

  # Check if user already exists and is not a member
  existing_user = User.find_by(email: email)
  if existing_user && existing_user.member_of?(organization)
    puts "⚠️  Skipping invitation for #{email} - already a member of #{organization.name}"
    next
  end

  invitation = organization.invite_user!(email, invited_by: invited_by)
  if invitation
    puts "✅ Invitation created: #{email} invited to #{organization.name} by #{invited_by.email}"
  else
    puts "⚠️  Failed to create invitation for #{email} to #{organization.name}"
  end
end

puts "\n🎉 Seeding completed!"
puts "Total users created: #{User.count}"
puts "Verified users: #{User.where(verified: true).count}"
puts "Unverified users: #{User.where(verified: false).count}"
puts "Total colleges: #{College.count}" if defined?(College)
puts "Total organizations: #{Organization.count}"
puts "Total invitations: #{Invitation.count}"
puts "Active invitations: #{Invitation.active.count}"

# Display login credentials for easy access
puts "\n🔑 Login Credentials for Testing:"
puts "Owner: owner@graditude.com / owner123456789"
puts "Admin: admin@graditude.com / admin123456789"
puts "Developer: developer@graditude.com / dev123456789"
puts "Test: test@graditude.com / test123456789"
puts "Sample: john.doe@example.com / john123456789"
puts "Unverified: pending@graditude.com / password123456"
puts "\n📧 Invited Users (can accept invitations):"
puts "Alex: alex.martinez@example.com / alex123456789"
puts "Emily: emily.chen@example.com / emily123456789"
puts "Ryan: ryan.thompson@example.com / ryan123456789"
puts "Sophia: sophia.kim@example.com / sophia123456789"
puts "Michael: michael.rodriguez@example.com / michael123456789"
puts "\n🎓 Invited Users from invitations_data:"
puts "CS Student: new.cs.student@stanford.edu / newcs123456789"
puts "CS Alumni: alumni.cs@stanford.edu / alumnics123456789"
puts "MIT Grad: grad.student@mit.edu / gradstudent123456789"
puts "Harvard MBA: mba.student@harvard.edu / mbastudent123456789"
puts "Berkeley PhD: phd.researcher@berkeley.edu / phdresearcher123456789"
puts "Yale Senior: senior.student@yale.edu / seniorstudent123456789"
