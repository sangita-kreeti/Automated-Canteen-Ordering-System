# frozen_string_literal: true

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

# rubocop:disable Metrics/BlockLength
ActiveRecord::Schema.define(version: 20_230_721_045_336) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'active_storage_attachments', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'record_type', null: false
    t.bigint 'record_id', null: false
    t.bigint 'blob_id', null: false
    t.datetime 'created_at', null: false
    t.index ['blob_id'], name: 'index_active_storage_attachments_on_blob_id'
    t.index %w[record_type record_id name blob_id], name: 'index_active_storage_attachments_uniqueness',
                                                    unique: true
  end

  create_table 'active_storage_blobs', force: :cascade do |t|
    t.string 'key', null: false
    t.string 'filename', null: false
    t.string 'content_type'
    t.text 'metadata'
    t.string 'service_name', null: false
    t.bigint 'byte_size', null: false
    t.string 'checksum', null: false
    t.datetime 'created_at', null: false
    t.index ['key'], name: 'index_active_storage_blobs_on_key', unique: true
  end

  create_table 'active_storage_variant_records', force: :cascade do |t|
    t.bigint 'blob_id', null: false
    t.string 'variation_digest', null: false
    t.index %w[blob_id variation_digest], name: 'index_active_storage_variant_records_uniqueness', unique: true
  end

  create_table 'channels', force: :cascade do |t|
    t.integer 'chef_id'
    t.integer 'employee_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'companies', force: :cascade do |t|
    t.string 'name'
    t.string 'address'
    t.float 'latitude'
    t.float 'longitude'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'food_categories', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'food_menus', force: :cascade do |t|
    t.bigint 'user_id'
    t.bigint 'food_store_id'
    t.bigint 'food_category_id'
    t.string 'title'
    t.float 'price'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['food_category_id'], name: 'index_food_menus_on_food_category_id'
    t.index ['food_store_id'], name: 'index_food_menus_on_food_store_id'
    t.index ['user_id'], name: 'index_food_menus_on_user_id'
  end

  create_table 'food_stores', force: :cascade do |t|
    t.string 'name'
    t.string 'address'
    t.float 'latitude'
    t.float 'longitude'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'messages', force: :cascade do |t|
    t.text 'content'
    t.integer 'sender_id'
    t.integer 'recipient_id'
    t.integer 'channel_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'notifications', force: :cascade do |t|
    t.bigint 'user_id', null: false
    t.bigint 'order_id'
    t.text 'message'
    t.boolean 'read', default: false
    t.integer 'notification_type'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['order_id'], name: 'index_notifications_on_order_id'
    t.index ['user_id'], name: 'index_notifications_on_user_id'
  end

  create_table 'orders', force: :cascade do |t|
    t.text 'food_item_names', default: [], array: true
    t.integer 'quantities', default: [], array: true
    t.text 'food_store_names', default: [], array: true
    t.integer 'prices', default: [], array: true
    t.text 'special_ingredients', default: [], array: true
    t.bigint 'user_id'
    t.string 'company_name'
    t.string 'status'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['user_id'], name: 'index_orders_on_user_id'
  end

  create_table 'photos', force: :cascade do |t|
    t.string 'image'
    t.bigint 'user_id'
    t.bigint 'food_store_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['food_store_id'], name: 'index_photos_on_food_store_id'
    t.index ['user_id'], name: 'index_photos_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email'
    t.string 'password_digest'
    t.integer 'role'
    t.string 'username'
    t.string 'uid'
    t.string 'provider'
    t.string 'name'
    t.string 'phone_no'
    t.integer 'company_id'
    t.integer 'food_store_id'
    t.boolean 'approved', default: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  add_foreign_key 'active_storage_attachments', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'active_storage_variant_records', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'food_menus', 'food_categories'
  add_foreign_key 'food_menus', 'food_stores'
  add_foreign_key 'food_menus', 'users'
  add_foreign_key 'orders', 'users'
  add_foreign_key 'photos', 'food_stores'
  add_foreign_key 'photos', 'users'
end
# rubocop:enable Metrics/BlockLength
