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

ActiveRecord::Schema.define(version: 20150124174315) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "journal_entries", force: :cascade do |t|
    t.date     "entry_date"
    t.text     "description"
    t.integer  "purity"
    t.boolean  "lack_of_discipline"
    t.integer  "fitness"
    t.integer  "devotional"
    t.integer  "chrissy"
    t.integer  "relational"
    t.integer  "discipline"
    t.integer  "facepicking"
    t.integer  "stress"
    t.boolean  "sick"
    t.boolean  "flossed"
    t.boolean  "workout"
    t.string   "health_statement"
    t.text     "to_do"
    t.text     "memory_verse"
    t.string   "friends_in_focus"
    t.text     "problem_of_the_day"
    t.boolean  "problem_attempted"
    t.boolean  "problem_solved"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.text     "friends"
    t.text     "workout_done"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
