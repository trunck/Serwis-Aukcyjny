# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091121165418) do

  create_table "auctions", :force => true do |t|
    t.integer  "user_id",                                                                                    :null => false
    t.datetime "start",                                                                                      :null => false
    t.datetime "end",                                                                                        :null => false
    t.text     "description",                                                                                :null => false
    t.integer  "number_of_products",                                                      :default => 1
    t.decimal  "minimal_price",                            :precision => 14, :scale => 4, :default => 0.0
    t.decimal  "buy_now_price",                            :precision => 14, :scale => 4, :default => 0.0
    t.decimal  "minimal_bidding_difference",               :precision => 10, :scale => 2, :default => 5.0
    t.boolean  "activated",                                                               :default => false
    t.integer  "auctionable_id"
    t.string   "auctionable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "activation_token",           :limit => 20
  end

  create_table "auctions_categories", :id => false, :force => true do |t|
    t.integer  "auction_id"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "banners", :force => true do |t|
    t.string   "url"
    t.integer  "pagerank"
    t.integer  "users_daily"
    t.integer  "width",       :null => false
    t.integer  "height",      :null => false
    t.integer  "x_pos",       :null => false
    t.integer  "y_pos",       :null => false
    t.integer  "auction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bids", :force => true do |t|
    t.integer  "user_id"
    t.integer  "auction_id"
    t.decimal  "offered_price",           :precision => 14, :scale => 4
    t.boolean  "cancelled",                                              :default => false
    t.boolean  "asking_for_cancellation",                                :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "buy_now_auctions", :force => true do |t|
    t.decimal  "price",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["name"], :name => "index_categories_on_name", :unique => true

  create_table "interests", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "interests", ["name"], :name => "index_interests_on_name", :unique => true

  create_table "interests_users", :id => false, :force => true do |t|
    t.integer  "interest_id", :null => false
    t.integer  "user_id",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pop_ups", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.integer  "auction_id"
    t.text     "product_token",                    :null => false
    t.text     "url"
    t.boolean  "activated",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "authorizable_type"
    t.integer  "authorizable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "authorizable_type", "authorizable_id"], :name => "index_roles_on_name_and_authorizable_type_and_authorizable_id", :unique => true

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "role_id",    :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "site_links", :force => true do |t|
    t.string   "url",         :null => false
    t.integer  "pagerank",    :null => false
    t.integer  "users_daily"
    t.integer  "auction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sponsored_articles", :force => true do |t|
    t.string   "url"
    t.integer  "pagerank"
    t.integer  "users_daily"
    t.integer  "words_number",    :default => 0, :null => false
    t.integer  "number_of_links"
    t.integer  "auction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                                :null => false
    t.string   "email",                                :null => false
    t.string   "crypted_password",                     :null => false
    t.string   "password_salt",                        :null => false
    t.string   "persistence_token",                    :null => false
    t.string   "single_access_token",                  :null => false
    t.string   "perishable_token",                     :null => false
    t.integer  "login_count",         :default => 0,   :null => false
    t.integer  "failed_login_count",  :default => 0,   :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "first_name",          :default => " ", :null => false
    t.string   "surname",             :default => " ", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
