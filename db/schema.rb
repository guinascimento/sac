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

ActiveRecord::Schema.define(:version => 20100428164733) do

  create_table "alerts", :id => false, :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "ticket_id",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "alerts", ["ticket_id", "user_id"], :name => "index_alerts_on_ticket_id_and_user_id", :unique => true
  add_index "alerts", ["ticket_id"], :name => "index_alerts_on_ticket_id"
  add_index "alerts", ["user_id"], :name => "index_alerts_on_user_id"

  create_table "attachments", :force => true do |t|
    t.string   "data_file_name",                   :null => false
    t.string   "data_content_type",                :null => false
    t.integer  "data_file_size",                   :null => false
    t.integer  "download_count",    :default => 0
    t.integer  "ticket_id",                        :null => false
    t.integer  "user_id",                          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attachments", ["ticket_id"], :name => "index_attachments_on_ticket_id"
  add_index "attachments", ["user_id"], :name => "index_attachments_on_user_id"

  create_table "categories", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "comments", :force => true do |t|
    t.text     "comment",    :null => false
    t.integer  "ticket_id",  :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["ticket_id"], :name => "index_comments_on_ticket_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "contacts", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name",    :null => false
    t.string   "email",        :null => false
    t.string   "mobile_phone"
    t.string   "office_phone"
    t.string   "affiliation"
    t.text     "notes"
    t.datetime "disabled_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "name",        :null => false
    t.datetime "disabled_at"
  end

  create_table "incidents", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "priorities", :force => true do |t|
    t.string   "name",        :null => false
    t.datetime "disabled_at"
  end

  create_table "statuses", :force => true do |t|
    t.string   "name",        :null => false
    t.datetime "disabled_at"
  end

  create_table "tickets", :force => true do |t|
    t.string   "subject",                       :null => false
    t.text     "message"
    t.integer  "category_id",                   :null => false
    t.integer  "status_id",                     :null => false
    t.integer  "incident_id",                   :null => false
    t.integer  "created_by",                    :null => false
    t.integer  "owned_by"
    t.datetime "closed_at"
    t.integer  "comments_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tickets", ["category_id"], :name => "index_tickets_on_category_id"
  add_index "tickets", ["created_by"], :name => "index_tickets_on_created_by"
  add_index "tickets", ["incident_id"], :name => "index_tickets_on_incident_id"
  add_index "tickets", ["owned_by"], :name => "index_tickets_on_owned_by"
  add_index "tickets", ["status_id"], :name => "index_tickets_on_status_id"

  create_table "users", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
  end

end
