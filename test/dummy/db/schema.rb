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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 0) do

  create_table "another_models", :force => true do |t|
    t.string "first_name"
    t.string "last_name"
  end

  create_table "archived_another_models", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "deleted_at"
    t.integer  "another_model_id"
  end

  create_table "archived_some_models", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "random_array"
    t.string   "some_hash"
    t.datetime "deleted_at"
  end

  create_table "some_models", :force => true do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "random_array"
    t.string "some_hash"
  end

  create_table "archived_my_namespaced_models", :force => true do |t|
    t.integer  "my_namespaced_model_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "random_array"
    t.string   "some_hash"
    t.datetime "deleted_at"
  end

  create_table "my_namespaced_models", :force => true do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "random_array"
    t.string "some_hash"
  end
end
