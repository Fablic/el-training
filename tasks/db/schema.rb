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

ActiveRecord::Schema.define(version: 2021_07_12_005853) do

  create_table "master_task_priorities", id: { type: :integer, limit: 1 }, charset: "utf8", force: :cascade do |t|
    t.string "priority", limit: 64, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "master_task_statuses", id: { type: :integer, limit: 1 }, charset: "utf8", force: :cascade do |t|
    t.string "status", limit: 64, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "task_links", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "task_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tasks", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "task_name", limit: 64, null: false
    t.integer "status_id", limit: 1, null: false
    t.integer "priority_id", limit: 1, null: false
    t.string "label", limit: 64
    t.datetime "limit_date", precision: 6
    t.string "detail"
    t.datetime "deleted_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_at"], name: "index_tasks_on_created_at"
    t.index ["limit_date"], name: "index_tasks_on_limit_date"
    t.index ["status_id"], name: "index_tasks_on_status_id"
  end

  create_table "users", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "user_name", limit: 64, null: false
    t.string "email", limit: 128, null: false
    t.string "password", limit: 128, null: false
    t.boolean "role", null: false
    t.datetime "deleted_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
