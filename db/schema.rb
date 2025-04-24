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

ActiveRecord::Schema[8.0].define(version: 2025_04_23_145035) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.boolean "is_disabled", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["is_disabled"], name: "index_categories_on_is_disabled"
    t.index ["name"], name: "index_categories_on_name", unique: true, where: "(is_disabled = false)"
  end

  create_table "categories_quotes", id: false, force: :cascade do |t|
    t.bigint "quote_id", null: false
    t.bigint "category_id", null: false
    t.index ["category_id", "quote_id"], name: "index_categories_quotes_on_category_id_and_quote_id"
    t.index ["quote_id", "category_id"], name: "index_categories_quotes_on_quote_id_and_category_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "company_name"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "position"
    t.string "address"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_name"], name: "index_customers_on_company_name", unique: true
  end

  create_table "items", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.bigint "category_id"
    t.jsonb "fixed_parameters", default: {}
    t.jsonb "pricing_options", default: {}
    t.boolean "is_disabled", default: false, null: false
    t.boolean "is_fixed", default: false
    t.boolean "is_open", default: false
    t.boolean "is_selectable_options", default: false
    t.text "open_parameters_label", default: [], array: true
    t.text "formula_parameters", default: [], array: true
    t.string "calculation_formula"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_items_on_category_id"
    t.index ["name", "category_id"], name: "index_items_on_name_and_category_id", unique: true
  end

  create_table "quote_items", force: :cascade do |t|
    t.bigint "quote_id", null: false
    t.bigint "item_id", null: false
    t.jsonb "pricing_parameters", default: {}, null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.decimal "discount", precision: 5, scale: 2, default: "0.0", null: false
    t.decimal "final_price", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_quote_items_on_item_id"
    t.index ["quote_id"], name: "index_quote_items_on_quote_id"
  end

  create_table "quotes", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "user_id", null: false
    t.decimal "total_price", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "step", default: "customer_info", null: false
    t.index ["customer_id"], name: "index_quotes_on_customer_id"
    t.index ["user_id"], name: "index_quotes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "items", "categories"
  add_foreign_key "quote_items", "items"
  add_foreign_key "quote_items", "quotes"
  add_foreign_key "quotes", "customers"
  add_foreign_key "quotes", "users"
end
