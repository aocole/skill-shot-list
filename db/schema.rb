# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(version: 20181019191636) do

  create_table "areas", force: true do |t|
    t.string   "name",        limit: 510, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug", limit: 510
  end

  create_table "localities", force: true do |t|
    t.string   "name",        limit: 510, null: false
    t.integer  "area_id",                    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug", limit: 510
  end

  add_index "localities", ["area_id"], name: "localities_area_id_idx"

  create_table "locations", force: true do |t|
    t.string   "name",        limit: 510
    t.string   "address",     limit: 510
    t.string   "url",         limit: 510
    t.string   "phone",       limit: 510
    t.boolean  "all_ages"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "city",        limit: 510
    t.string   "state",       limit: 510
    t.string   "postal_code", limit: 510
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "locality_id"
    t.string   "cached_slug", limit: 510
    t.datetime "deleted_at"
  end

  create_table "machine_changes", force: true do |t|
    t.integer  "machine_id",  null: false
    t.string   "change_type", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "machines", force: true do |t|
    t.integer  "title_id",      null: false
    t.integer  "location_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id", null: false
    t.integer  "deleted_by_id"
    t.datetime "deleted_at"
  end

  add_index "machines", ["created_by_id"], name: "machines_creator_id_idx"
  add_index "machines", ["location_id"], name: "machines_location_id_idx"
  add_index "machines", ["title_id"], name: "machines_title_id_idx"

  create_table "slugs", force: true do |t|
    t.string   "scope",      limit: 510
    t.string   "slug",       limit: 510
    t.integer  "record_id"
    t.datetime "created_at"
  end

  create_table "titles", force: true do |t|
    t.string   "name",       limit: 510
    t.integer  "ipdb_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",     limit: 510
  end

  add_index "titles", ["ipdb_id"], name: "titles_ipdb_id_key", unique: true

  create_table "users", force: true do |t|
    t.string   "email",             limit: 510,                 null: false
    t.string   "password_hash",     limit: 510,                 null: false
    t.string   "password_salt",     limit: 510,                 null: false
    t.boolean  "admin",                                            null: false
    t.string   "persistence_token", limit: 510,                 null: false
    t.integer  "login_count",                      default: 0,  null: false
    t.datetime "last_login_at"
    t.string   "initials",          limit: 510
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "perishable_token",  limit: 510, default: "", null: false
  end

  add_index "users", ["email"], name: "users_email_key", unique: true

  add_foreign_key "localities", "areas", name: "localities_area_id_fk"

  add_foreign_key "machine_changes", "machines", name: "machine_changes_machine_id_fk"

  add_foreign_key "machines", "locations", name: "machines_location_id_fk", dependent: :delete
  add_foreign_key "machines", "titles", name: "machines_title_id_fk", dependent: :delete
  add_foreign_key "machines", "users", name: "machines_creator_id_fk", column: "created_by_id", dependent: :nullify
  add_foreign_key "machines", "users", name: "machines_deleted_by_id_fk", column: "deleted_by_id", dependent: :nullify

end
