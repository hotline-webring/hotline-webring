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

ActiveRecord::Schema.define(version: 2020_07_03_012614) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blocked_referrers", force: :cascade do |t|
    t.string "host_with_path", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["host_with_path"], name: "index_blocked_referrers_on_host_with_path", unique: true
  end

  create_table "redirections", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "next_id", null: false
    t.string "slug", null: false
    t.text "url", null: false
    t.text "original_url", null: false
    t.index ["next_id"], name: "index_redirections_on_next_id", unique: true
    t.index ["slug"], name: "index_redirections_on_slug", unique: true
    t.index ["url"], name: "index_redirections_on_url", unique: true
  end

end
