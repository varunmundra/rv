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

ActiveRecord::Schema.define(version: 20140207102400) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "banks", force: true do |t|
    t.integer  "user_id"
    t.string   "name_of_bank"
    t.string   "account_num"
    t.string   "account_type"
    t.string   "mode_of_holding"
    t.string   "first_holder"
    t.string   "second_holder"
    t.string   "branch_address"
    t.string   "city"
    t.string   "ifsc_code"
    t.string   "micr_code"
    t.integer  "sip_mandate_status"
    t.integer  "sip_validity"
    t.float    "sip_upper_limit"
    t.string   "umrn"
    t.string   "reason"
    t.string   "bankid_pg"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "kycs", force: true do |t|
    t.integer  "user_id"
    t.string   "holding_priority"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "father_spouse_name"
    t.string   "gender"
    t.string   "marital_status"
    t.date     "date_of_birth"
    t.string   "nationality"
    t.string   "residence_status"
    t.string   "pan"
    t.string   "proof_of_identity"
    t.string   "c_house_no"
    t.string   "c_street_name"
    t.string   "c_area_name"
    t.string   "c_city_town_village"
    t.string   "c_state"
    t.string   "c_country"
    t.string   "c_postal_code"
    t.string   "c_landline"
    t.string   "c_mobile"
    t.string   "c_email"
    t.string   "c_proof_of_address"
    t.boolean  "same"
    t.string   "p_house_no"
    t.string   "p_street_name"
    t.string   "p_area_name"
    t.string   "p_city_town_village"
    t.string   "p_state"
    t.string   "p_country"
    t.string   "p_postal_code"
    t.string   "p_landline"
    t.string   "p_mobile"
    t.string   "p_email"
    t.string   "p_proof_of_address"
    t.float    "annual_income"
    t.string   "occupation"
    t.string   "pep_status"
    t.string   "nominee_name"
    t.string   "nominee_relation"
    t.string   "nominee_address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "part_validation"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "admin",                  default: false
    t.integer  "kyc_status",             default: 1
    t.integer  "bank_status",            default: 1
    t.string   "pg_user_code"
    t.string   "karvy_user_code"
    t.string   "cams_user_code"
    t.string   "ft_user_code"
    t.string   "bnp_user_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "tax_status"
    t.string   "holding_type"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
