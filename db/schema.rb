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

ActiveRecord::Schema.define(:version => 20120316184117) do

  create_table "areas", :force => true do |t|
    t.string   "name",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug"
  end

  add_index "areas", ["cached_slug"], :name => "index_areas_on_cached_slug"

  create_table "localities", :force => true do |t|
    t.string   "name",        :null => false
    t.integer  "area_id",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug"
  end

  add_index "localities", ["cached_slug"], :name => "index_localities_on_cached_slug"

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "url"
    t.string   "phone"
    t.boolean  "all_ages"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "locality_id"
    t.string   "cached_slug"
  end

  add_index "locations", ["cached_slug"], :name => "index_locations_on_cached_slug"

  create_table "machines", :force => true do |t|
    t.integer  "title_id",    :null => false
    t.integer  "location_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
  end

  create_table "slugs", :force => true do |t|
    t.string   "scope"
    t.string   "slug"
    t.integer  "record_id"
    t.datetime "created_at"
  end

  add_index "slugs", ["scope", "record_id", "created_at"], :name => "index_slugs_on_scope_and_record_id_and_created_at"
  add_index "slugs", ["scope", "record_id"], :name => "index_slugs_on_scope_and_record_id"
  add_index "slugs", ["scope", "slug", "created_at"], :name => "index_slugs_on_scope_and_slug_and_created_at"
  add_index "slugs", ["scope", "slug"], :name => "index_slugs_on_scope_and_slug"

  create_table "titles", :force => true do |t|
    t.string   "name"
    t.integer  "ipdb_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
  end

  add_index "titles", ["ipdb_id"], :name => "index_titles_on_ipdb_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                                :null => false
    t.string   "password_hash",                        :null => false
    t.string   "password_salt",                        :null => false
    t.boolean  "admin",             :default => false, :null => false
    t.string   "persistence_token",                    :null => false
    t.integer  "login_count",       :default => 0,     :null => false
    t.datetime "last_login_at"
    t.string   "initials"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "perishable_token",  :default => "",    :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"

  add_foreign_key "localities", "areas", :name => "localities_area_id_fk"

  add_foreign_key "machines", "locations", :name => "machines_location_id_fk", :dependent => :delete
  add_foreign_key "machines", "titles", :name => "machines_title_id_fk", :dependent => :delete
  add_foreign_key "machines", "users", :name => "machines_creator_id_fk", :column => "creator_id", :dependent => :nullify

end
