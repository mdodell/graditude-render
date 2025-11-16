# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_10_27_013137) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "colleges", force: :cascade do |t|
    t.string "name"
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invitations", force: :cascade do |t|
    t.string "invitable_type", null: false
    t.bigint "invitable_id", null: false
    t.string "email", null: false
    t.string "invite_code", null: false
    t.datetime "expires_at", null: false
    t.datetime "accepted_at"
    t.bigint "accepted_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "accepted_by_id" ], name: "index_invitations_on_accepted_by_id"
    t.index [ "expires_at" ], name: "index_invitations_on_expires_at"
    t.index [ "invitable_type", "invitable_id", "email" ], name: "index_invitations_on_invitable_type_and_invitable_id_and_email"
    t.index [ "invitable_type", "invitable_id" ], name: "index_invitations_on_invitable"
    t.index [ "invite_code" ], name: "index_invitations_on_invite_code", unique: true
  end

  create_table "organization_colleges", id: false, force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "college_id", null: false
    t.index [ "college_id" ], name: "index_organization_colleges_on_college_id"
    t.index [ "organization_id", "college_id" ], name: "index_organization_colleges_on_organization_id_and_college_id", unique: true
    t.index [ "organization_id" ], name: "index_organization_colleges_on_organization_id"
  end

  create_table "organization_memberships", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "user_id", null: false
    t.bigint "invitation_id"
    t.datetime "joined_at", precision: nil, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "invitation_id" ], name: "index_organization_memberships_on_invitation_id"
    t.index [ "organization_id", "user_id" ], name: "index_organization_memberships_on_organization_id_and_user_id", unique: true
    t.index [ "organization_id" ], name: "index_organization_memberships_on_organization_id"
    t.index [ "user_id", "organization_id" ], name: "index_organization_memberships_on_user_id_and_organization_id"
    t.index [ "user_id" ], name: "index_organization_memberships_on_user_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.string "domain"
    t.string "description", limit: 250
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "domain" ], name: "index_organizations_on_domain", unique: true
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "name", "resource_type", "resource_id" ], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index [ "resource_type", "resource_id" ], name: "index_roles_on_resource"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "user_id" ], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.boolean "verified", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index [ "email" ], name: "index_users_on_email", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index [ "role_id" ], name: "index_users_roles_on_role_id"
    t.index [ "user_id", "role_id" ], name: "index_users_roles_on_user_id_and_role_id"
    t.index [ "user_id" ], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "invitations", "users", column: "accepted_by_id"
  add_foreign_key "organization_colleges", "colleges"
  add_foreign_key "organization_colleges", "organizations"
  add_foreign_key "organization_memberships", "invitations"
  add_foreign_key "organization_memberships", "organizations"
  add_foreign_key "organization_memberships", "users"
  add_foreign_key "sessions", "users"
end
