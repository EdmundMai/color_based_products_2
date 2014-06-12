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

ActiveRecord::Schema.define(version: 20140612160113) do

  create_table "addresses", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "street_address"
    t.string   "street_address2"
    t.string   "zip_code"
    t.string   "phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "state_id"
    t.string   "city"
    t.string   "type"
    t.integer  "order_id"
  end

  create_table "cart_items", force: true do |t|
    t.integer  "cart_id"
    t.integer  "variant_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "carts", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "colors", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "line_items", force: true do |t|
    t.integer  "order_id"
    t.integer  "quantity"
    t.integer  "variant_id"
    t.integer  "unit_price_cents",    default: 0,     null: false
    t.string   "unit_price_currency", default: "USD", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "materials", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.integer  "user_id"
    t.datetime "order_date"
    t.integer  "total_cents",       default: 0,     null: false
    t.string   "total_currency",    default: "USD", null: false
    t.integer  "shipping_cents",    default: 0,     null: false
    t.string   "shipping_currency", default: "USD", null: false
    t.integer  "tax_cents",         default: 0,     null: false
    t.string   "tax_currency",      default: "USD", null: false
    t.integer  "subtotal_cents",    default: 0,     null: false
    t.string   "subtotal_currency", default: "USD", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
  end

  create_table "product_images", force: true do |t|
    t.string   "image"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sort_order"
    t.integer  "products_color_id"
  end

  create_table "products", force: true do |t|
    t.string   "name"
    t.boolean  "active"
    t.string   "page_title"
    t.text     "meta_description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vendor_id"
    t.text     "short_description"
    t.text     "long_description"
    t.integer  "shape_id"
    t.integer  "material_id"
    t.integer  "category_id"
    t.boolean  "taxable"
  end

  create_table "products_colors", force: true do |t|
    t.integer  "color_id"
    t.integer  "product_id"
    t.boolean  "mens"
    t.boolean  "womens"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "mens_sort_order"
    t.integer  "womens_sort_order"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "shapes", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sizes", force: true do |t|
    t.string   "name"
    t.integer  "sort_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "states", force: true do |t|
    t.string   "long_name"
    t.string   "short_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taxes", force: true do |t|
    t.integer  "state_id"
    t.string   "zip_code"
    t.decimal  "rate",       precision: 8, scale: 5
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "guest"
    t.string   "guest_email"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  create_table "variants", force: true do |t|
    t.decimal  "weight",            precision: 30, scale: 2
    t.string   "measurements"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sku"
    t.boolean  "active"
    t.integer  "price_cents",                                default: 0
    t.string   "price_currency",                             default: "USD", null: false
    t.integer  "products_color_id"
    t.integer  "size_id"
    t.boolean  "in_stock"
  end

  create_table "vendors", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
