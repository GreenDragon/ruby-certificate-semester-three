# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090528151746) do

  create_table "mentors", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "zipcode"
    t.string   "home_phone"
    t.string   "cell_phone"
    t.string   "email"
    t.string   "race"
    t.integer  "age"
    t.boolean  "time_afternoon"
    t.boolean  "time_evening"
    t.boolean  "time_weekends"
    t.string   "exp_org_1"
    t.string   "exp_title_1"
    t.datetime "exp_start_1"
    t.datetime "exp_stop_1"
    t.string   "exp_org_2"
    t.string   "exp_title_2"
    t.datetime "exp_start_2"
    t.datetime "exp_stop_2"
    t.string   "exp_org_3"
    t.string   "exp_title_3"
    t.datetime "exp_start_3"
    t.datetime "exp_stop_3"
    t.string   "exp_org_4"
    t.string   "exp_title_4"
    t.datetime "exp_start_4"
    t.datetime "exp_stop_4"
    t.text     "worked_with_middle_school"
    t.text     "two_activities"
    t.text     "helpful_support"
    t.string   "seattle_location"
    t.string   "brothers_sisters"
    t.string   "have_children"
    t.string   "have_pets"
    t.text     "fav_subject"
    t.text     "hobbies"
    t.text     "work_exp_mentee"
    t.text     "new_activities_mentee"
    t.text     "describe_yourself"
    t.text     "why_be_a_mentor"
    t.text     "what_skills_bring_you"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state"
    t.decimal  "lat",                       :precision => 15, :scale => 10
    t.decimal  "lng",                       :precision => 15, :scale => 10
  end

  create_table "referrals", :force => true do |t|
    t.string   "reference_for"
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zipcode"
    t.string   "day_phone"
    t.string   "evening_phone"
    t.string   "cell_phone"
    t.string   "email"
    t.integer  "known_months"
    t.integer  "known_years"
    t.text     "what_capacity"
    t.text     "working_with_children"
    t.text     "any_concerns"
    t.integer  "role_model"
    t.integer  "reliability"
    t.integer  "creativity"
    t.integer  "enthusiasm"
    t.integer  "cultural_awareness"
    t.integer  "patience"
    t.text     "additional_comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                             :null => false
    t.string   "email",                             :null => false
    t.string   "crypted_password",                  :null => false
    t.string   "password_salt",                     :null => false
    t.string   "persistence_token",                 :null => false
    t.integer  "login_count",        :default => 0, :null => false
    t.integer  "failed_login_count", :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
