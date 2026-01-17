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

ActiveRecord::Schema[8.1].define(version: 2026_01_17_120254) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "analysis_reports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at"
    t.jsonb "score_breakdown", default: {}
    t.bigint "stock_id", null: false
    t.integer "total_score", null: false
    t.datetime "updated_at", null: false
    t.index ["stock_id"], name: "index_analysis_reports_on_stock_id"
  end

  create_table "investment_profiles", force: :cascade do |t|
    t.integer "actual_score"
    t.jsonb "biases", default: {}
    t.datetime "created_at", null: false
    t.string "risk_tolerance"
    t.integer "survey_score"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_investment_profiles_on_user_id"
  end

  create_table "investment_records", force: :cascade do |t|
    t.string "action", null: false
    t.datetime "created_at", null: false
    t.integer "pre_rating"
    t.decimal "price", precision: 12, scale: 2, null: false
    t.integer "quantity", null: false
    t.string "reason_tags", default: [], array: true
    t.bigint "stock_id", null: false
    t.datetime "traded_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["stock_id"], name: "index_investment_records_on_stock_id"
    t.index ["user_id"], name: "index_investment_records_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "stock_metrics", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "data_date"
    t.decimal "debt_ratio"
    t.decimal "operating_margin"
    t.decimal "pbr"
    t.decimal "per"
    t.integer "profit_growth_years"
    t.decimal "roe"
    t.bigint "stock_id", null: false
    t.datetime "updated_at", null: false
    t.index ["stock_id"], name: "index_stock_metrics_on_stock_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.string "sector"
    t.string "symbol"
    t.datetime "updated_at", null: false
    t.index ["symbol"], name: "index_stocks_on_symbol", unique: true
  end

  create_table "survey_responses", force: :cascade do |t|
    t.integer "answer_value"
    t.datetime "created_at", null: false
    t.string "question_key"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_survey_responses_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.boolean "is_admin", default: false, null: false
    t.string "name"
    t.string "password_digest", null: false
    t.datetime "suspended_at"
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "analysis_reports", "stocks"
  add_foreign_key "investment_profiles", "users"
  add_foreign_key "investment_records", "stocks"
  add_foreign_key "investment_records", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "stock_metrics", "stocks"
  add_foreign_key "survey_responses", "users"
end
