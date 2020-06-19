# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_02_085910) do

  create_table "comments", force: :cascade do |t|
    t.text "content"
    t.integer "user_id", null: false
    t.integer "contribution_id", null: false
    t.integer "comment_id"
    t.boolean "voted", default: false
    t.integer "points", default: 0
    t.string "user_name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["comment_id"], name: "index_comments_on_comment_id"
    t.index ["contribution_id"], name: "index_comments_on_contribution_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "contributions", force: :cascade do |t|
    t.string "title"
    t.string "url"
    t.text "text"
    t.integer "points", default: 1
    t.string "nametype"
    t.integer "user_id", null: false
    t.string "type"
    t.boolean "voted", default: false
    t.string "user_name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["url"], name: "index_contributions_on_url", unique: true
    t.index ["user_id"], name: "index_contributions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "showdead", default: "no"
    t.string "noprocrast", default: "no"
    t.string "about", default: ""
    t.integer "maxvisit", default: 20
    t.integer "minaway", default: 180
    t.integer "delay", default: 0
    t.integer "karma", default: 1
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "api_key", null: false
    t.index ["api_key"], name: "index_users_on_api_key", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "comments", "comments"
  add_foreign_key "comments", "contributions"
  add_foreign_key "comments", "users"
  add_foreign_key "contributions", "users"
end
