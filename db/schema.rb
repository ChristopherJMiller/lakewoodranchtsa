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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170514172738) do

  create_table "accountability_logs", force: :cascade do |t|
    t.date     "dueby"
    t.date     "closingdate"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "announcements", force: :cascade do |t|
    t.string   "title"
    t.string   "body"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "announcements", ["user_id"], name: "index_announcements_on_user_id"

  create_table "attendees", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "sign_up_sheet_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "attendees", ["sign_up_sheet_id"], name: "index_attendees_on_sign_up_sheet_id"
  add_index "attendees", ["user_id"], name: "index_attendees_on_user_id"

  create_table "documents", force: :cascade do |t|
    t.string   "title"
    t.string   "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "max_members_per_team"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "image_path"
    t.string   "cover_path"
  end

  create_table "sign_up_sheets", force: :cascade do |t|
    t.string   "name"
    t.date     "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "submissions", force: :cascade do |t|
    t.integer  "accountability_log_id"
    t.integer  "user_id"
    t.text     "binderstatus"
    t.text     "tasks"
    t.text     "goals"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "submissions", ["accountability_log_id"], name: "index_submissions_on_accountability_log_id"
  add_index "submissions", ["user_id"], name: "index_submissions_on_user_id"

  create_table "team_members", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "admin"
  end

  add_index "team_members", ["team_id"], name: "index_team_members_on_team_id"
  add_index "team_members", ["user_id"], name: "index_team_members_on_user_id"

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.integer  "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "closed"
  end

  add_index "teams", ["event_id"], name: "index_teams_on_event_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "rank"
    t.string   "password_digest"
    t.string   "verify_token"
    t.boolean  "verified"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "disabled",        default: false
  end

end
