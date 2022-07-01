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

ActiveRecord::Schema[7.0].define(version: 2022_06_28_192624) do
  create_table "orders", force: :cascade do |t|
    t.string "requester"
    t.string "spot"
    t.text "defect"
    t.boolean "backup"
    t.text "performed_service"
    t.text "obs"
    t.integer "removal_technician"
    t.integer "maintenance_technician"
    t.date "start_date"
    t.date "end_date"
    t.string "status", default: "Aberto"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "stuff_id"
  end

  create_table "schools", force: :cascade do |t|
    t.string "segment"
    t.string "name", null: false
    t.string "address", null: false
    t.integer "address_number", null: false
    t.string "district", null: false
    t.string "zip_code", null: false
    t.string "phone", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["name"], name: "index_schools_on_name", unique: true
    t.index ["phone"], name: "index_schools_on_phone", unique: true
    t.index ["zip_code"], name: "index_schools_on_zip_code", unique: true
  end

  create_table "stuffs", force: :cascade do |t|
    t.string "category"
    t.string "brand"
    t.integer "patrimony"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: ""
    t.string "name", default: ""
    t.string "encrypted_password", default: "", null: false
    t.integer "user_level", default: 1, null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username", default: "", null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
