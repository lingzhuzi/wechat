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

ActiveRecord::Schema.define(version: 20141126041412) do

  create_table "wx_apps", force: true do |t|
    t.string   "name"
    t.integer  "icon_id"
    t.string   "wx_id"
    t.string   "app_id"
    t.string   "token"
    t.string   "access_token"
    t.text     "sceret"
    t.datetime "refreshed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wx_apps", ["icon_id"], name: "index_wx_apps_on_icon_id"

  create_table "wx_files", force: true do |t|
    t.string   "file_name"
    t.integer  "file_size"
    t.string   "mime_type"
    t.string   "digest"
    t.text     "description"
    t.integer  "app_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wx_files", ["app_id"], name: "index_wx_files_on_app_id"

  create_table "wx_messages", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.text     "original"
    t.string   "message_type"
    t.string   "event"
    t.string   "event_key"
    t.string   "to_user_name"
    t.string   "from_user_name"
    t.integer  "msg_id"
    t.integer  "app_id"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wx_messages", ["app_id"], name: "index_wx_messages_on_app_id"
  add_index "wx_messages", ["author_id"], name: "index_wx_messages_on_author_id"

  create_table "wx_users", force: true do |t|
    t.string   "nick_name"
    t.string   "remark_name"
    t.string   "open_id"
    t.integer  "app_id"
    t.integer  "avatar_id"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wx_users", ["app_id"], name: "index_wx_users_on_app_id"
  add_index "wx_users", ["avatar_id"], name: "index_wx_users_on_avatar_id"

end
