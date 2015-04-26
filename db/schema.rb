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

ActiveRecord::Schema.define(version: 20150426003320) do

  create_table "addresses", force: :cascade do |t|
    t.string   "street"
    t.string   "house_number"
    t.string   "city"
    t.string   "state"
    t.string   "postcode"
    t.string   "country"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "group_messages", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.string   "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "group_messages", ["group_id"], name: "index_group_messages_on_group_id"
  add_index "group_messages", ["user_id"], name: "index_group_messages_on_user_id"

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.string   "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "picture"
  end

  create_table "groups_users", id: false, force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "user_id",  null: false
  end

  add_index "groups_users", ["group_id", "user_id"], name: "index_groups_users_on_group_id_and_user_id"
  add_index "groups_users", ["user_id", "group_id"], name: "index_groups_users_on_user_id_and_group_id"

  create_table "user_messages", force: :cascade do |t|
    t.integer  "reciever_id"
    t.integer  "sender_id"
    t.string   "message"
    t.string   "picture"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "user_messages", ["reciever_id"], name: "index_user_messages_on_reciever_id"
  add_index "user_messages", ["sender_id"], name: "index_user_messages_on_sender_id"

  create_table "users", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "email",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username",        limit: 255
    t.string   "password_digest", limit: 255
    t.string   "first_name"
    t.date     "birthday"
    t.string   "details"
    t.integer  "address_id"
    t.string   "picture"
  end

  add_index "users", ["address_id"], name: "index_users_on_address_id"
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
