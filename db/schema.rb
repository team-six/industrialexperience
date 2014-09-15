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

ActiveRecord::Schema.define(version: 20140908193425) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "calls", force: true do |t|
    t.datetime "call_starttime"
    t.datetime "call_endTime"
    t.integer  "call_wait_period"
    t.integer  "employee_id"
    t.integer  "call_status_id"
    t.integer  "call_type_id"
    t.integer  "call_duration"
  end

  create_table "departments", force: true do |t|
    t.string   "dept_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_performance", force: true do |t|
    t.integer  "employee_id"
    t.integer  "ep_numCalls"
    t.integer  "ep_daysWorked"
    t.integer  "ep_hoursWored"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employee_skill", force: true do |t|
    t.integer "skill_id"
    t.integer "employee_id"
  end

  create_table "employee_statuses", force: true do |t|
    t.string   "es_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", force: true do |t|
    t.string   "employee_fname"
    t.string   "employee_lname"
    t.date     "employee_started"
    t.date     "employee_left"
    t.string   "employee_contact_num"
    t.string   "employee_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "religion_id"
    t.integer  "employee_status_id"
  end

  create_table "ep_missed_days", force: true do |t|
    t.integer  "employee_id"
    t.date     "epmd_date"
    t.string   "epmd_reason"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "religions", force: true do |t|
    t.string   "religion_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "religious_holidays", force: true do |t|
    t.integer "religion_id"
    t.date    "rh_startDate"
    t.string  "rh_name"
    t.date    "rh_endDate"
  end

  create_table "roles", force: true do |t|
    t.string   "role_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skills", force: true do |t|
    t.string   "skill_name"
    t.string   "skill_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "user_fname"
    t.string   "user_lname"
    t.string   "user_email"
    t.string   "password_digest"
    t.string   "remember_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sign_in_count"
    t.integer  "role_id"
    t.integer  "department_id"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
  end

end
