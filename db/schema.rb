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

ActiveRecord::Schema[7.2].define(version: 2026_05_14_003000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_logs", force: :cascade do |t|
    t.string "admin_email"
    t.string "action"
    t.string "resource_type"
    t.integer "resource_id"
    t.jsonb "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "billing_histories", force: :cascade do |t|
    t.string "enterprise_id", null: false
    t.bigint "admin_id"
    t.bigint "plan_id"
    t.bigint "previous_plan_id"
    t.decimal "charged_value", precision: 10, scale: 2
    t.decimal "previous_charged_value", precision: 10, scale: 2
    t.string "financial_status"
    t.string "previous_financial_status"
    t.date "next_billing_date"
    t.date "previous_next_billing_date"
    t.string "change_reason", null: false
    t.text "internal_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "change_type", default: "manual", null: false
    t.string "account_status"
    t.string "previous_account_status"
    t.date "payment_date"
    t.decimal "payment_amount", precision: 10, scale: 2
    t.string "payment_method"
    t.index ["admin_id"], name: "index_billing_histories_on_admin_id"
    t.index ["enterprise_id"], name: "index_billing_histories_on_enterprise_id"
    t.index ["plan_id"], name: "index_billing_histories_on_plan_id"
    t.index ["previous_plan_id"], name: "index_billing_histories_on_previous_plan_id"
  end

  create_table "enterprise_billings", force: :cascade do |t|
    t.string "enterprise_id", null: false
    t.bigint "plan_id"
    t.decimal "charged_value", precision: 10, scale: 2, default: "0.0"
    t.string "financial_status", default: "em_dia"
    t.date "next_billing_date"
    t.date "last_payment_date"
    t.string "account_status", default: "ativa"
    t.text "internal_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "billing_cycle", default: "monthly", null: false
    t.integer "tolerance_days", default: 14, null: false
    t.integer "block_after_days", default: 7, null: false
    t.boolean "auto_block_enabled", default: false, null: false
    t.index ["enterprise_id"], name: "index_enterprise_billings_on_enterprise_id"
    t.index ["plan_id"], name: "index_enterprise_billings_on_plan_id"
  end

  add_foreign_key "billing_histories", "admins"
end
