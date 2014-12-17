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

ActiveRecord::Schema.define(version: 20141211093457) do

  create_table "apps", force: true do |t|
    t.string   "name"
    t.integer  "icon_id"
    t.string   "wx_id"
    t.string   "app_id"
    t.string   "token"
    t.string   "access_token"
    t.text     "secret"
    t.datetime "refreshed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "apps", ["icon_id"], name: "index_apps_on_icon_id", using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "files", force: true do |t|
    t.string   "file_name"
    t.integer  "file_size"
    t.string   "mime_type"
    t.string   "digest"
    t.text     "description"
    t.integer  "app_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "files", ["app_id"], name: "index_files_on_app_id", using: :btree

  create_table "key_words", force: true do |t|
    t.string   "key"
    t.text     "content"
    t.integer  "app_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "key_words", ["app_id"], name: "index_key_words_on_app_id", using: :btree

  create_table "messages", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.text     "original"
    t.string   "message_type"
    t.string   "event"
    t.string   "event_key"
    t.string   "to_user_name"
    t.string   "from_user_name"
    t.string   "msg_id"
    t.integer  "file_id"
    t.integer  "app_id"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["app_id"], name: "index_messages_on_app_id", using: :btree
  add_index "messages", ["author_id"], name: "index_messages_on_author_id", using: :btree
  add_index "messages", ["file_id"], name: "index_messages_on_file_id", using: :btree

  create_table "user_app_records", force: true do |t|
    t.integer  "app_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_app_records", ["app_id"], name: "index_user_app_records_on_app_id", using: :btree
  add_index "user_app_records", ["user_id"], name: "index_user_app_records_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "nick_name"
    t.string   "remark_name"
    t.string   "open_id"
    t.integer  "app_id"
    t.integer  "avatar_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["app_id"], name: "index_users_on_app_id", using: :btree
  add_index "users", ["avatar_id"], name: "index_users_on_avatar_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
