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

ActiveRecord::Schema[7.1].define(version: 2024_07_30_141450) do
  create_schema "guest"

  create_table "clients", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "deliveries", force: :cascade do |t|
    t.bigint "transaction_id", null: false
    t.string "delivery_status", null: false
    t.datetime "shipping_date"
    t.datetime "delivery_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transaction_id"], name: "index_deliveries_on_transaction_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "Name"
    t.string "Description"
    t.decimal "Price", precision: 18
    t.string "url"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sysdiagrams", primary_key: "diagram_id", id: :integer, force: :cascade do |t|
    t.string "name", null: false
    t.integer "principal_id", null: false
    t.integer "version"
    t.binary "definition"
    t.index ["principal_id", "name"], name: "UK_principal_name", unique: true
  end

  create_table "transaction_details", force: :cascade do |t|
    t.bigint "transaction_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity"
    t.decimal "price", precision: 18
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_transaction_details_on_product_id"
    t.index ["transaction_id"], name: "index_transaction_details_on_transaction_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.datetime "transaction_date"
    t.string "status"
    t.decimal "total_amount", precision: 18
    t.decimal "base_fee", precision: 18
    t.decimal "delivery_fee", precision: 18
    t.string "transaction_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_transactions_on_client_id"
    t.index ["transaction_number"], name: "index_transactions_on_transaction_number"
  end

  add_foreign_key "deliveries", "transactions"
  add_foreign_key "transaction_details", "products"
  add_foreign_key "transaction_details", "transactions"
  add_foreign_key "transactions", "clients"
end
