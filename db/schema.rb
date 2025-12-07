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

ActiveRecord::Schema[8.1].define(version: 2025_12_01_073359) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "colleges", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.string "website"
  end

  create_table "invitations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "invitable_id", null: false
    t.string "invitable_type", null: false
    t.integer "status"
    t.string "token"
    t.datetime "updated_at", null: false
    t.index [ "invitable_type", "invitable_id" ], name: "index_invitations_on_invitable"
    t.index [ "token" ], name: "index_invitations_on_token"
  end

  create_table "memberships", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "memberable_id", null: false
    t.string "memberable_type", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index [ "memberable_type", "memberable_id" ], name: "index_memberships_on_memberable"
    t.index [ "user_id", "memberable_type", "memberable_id" ], name: "index_unique_membership", unique: true
    t.index [ "user_id" ], name: "index_memberships_on_user_id"
  end

  create_table "organization_colleges", id: false, force: :cascade do |t|
    t.bigint "college_id", null: false
    t.bigint "organization_id", null: false
    t.index [ "college_id" ], name: "index_organization_colleges_on_college_id"
    t.index [ "organization_id", "college_id" ], name: "index_organization_colleges_on_organization_id_and_college_id", unique: true
    t.index [ "organization_id" ], name: "index_organization_colleges_on_organization_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description", limit: 250
    t.string "domain"
    t.string "name"
    t.datetime "updated_at", null: false
    t.index [ "domain" ], name: "index_organizations_on_domain", unique: true
  end

  create_table "roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.bigint "resource_id"
    t.string "resource_type"
    t.datetime "updated_at", null: false
    t.index [ "name", "resource_type", "resource_id" ], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index [ "resource_type", "resource_id" ], name: "index_roles_on_resource"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index [ "user_id" ], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.boolean "verified", default: false, null: false
    t.index [ "email" ], name: "index_users_on_email", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "role_id"
    t.bigint "user_id"
    t.index [ "role_id" ], name: "index_users_roles_on_role_id"
    t.index [ "user_id", "role_id" ], name: "index_users_roles_on_user_id_and_role_id"
    t.index [ "user_id" ], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "memberships", "users"
  add_foreign_key "organization_colleges", "colleges"
  add_foreign_key "organization_colleges", "organizations"
  add_foreign_key "sessions", "users"
end
