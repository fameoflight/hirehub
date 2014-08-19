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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130311173026) do

  create_table "beta_list_users", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "email",      :null => false
    t.boolean  "email_sent"
    t.datetime "accepted"
    t.string   "token"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.text     "note"
  end

  add_index "beta_list_users", ["email"], :name => "index_beta_list_users_on_email", :unique => true
  add_index "beta_list_users", ["token"], :name => "index_beta_list_users_on_token", :unique => true

  create_table "code_problems", :force => true do |t|
    t.string   "name"
    t.text     "statement"
    t.string   "input"
    t.string   "output"
    t.integer  "score",         :default => 3
    t.integer  "user_id"
    t.integer  "timeout",       :default => 3
    t.string   "sample_input",  :default => ""
    t.string   "sample_output", :default => ""
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "collection_code_problems", :force => true do |t|
    t.integer  "collection_id"
    t.integer  "code_problem_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "collection_problems", :force => true do |t|
    t.integer  "collection_id"
    t.integer  "problem_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "collections", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "start_time"
    t.time     "duration"
    t.boolean  "reusable",   :default => false
    t.boolean  "public",     :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "interviews", :force => true do |t|
    t.integer  "user_id"
    t.string   "candidate_name"
    t.string   "candidate_email"
    t.integer  "candidate_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "timezone"
    t.text     "instruction"
    t.string   "url_hash"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "invite_problem_scores", :force => true do |t|
    t.integer  "invite_id"
    t.integer  "problem_id"
    t.integer  "score",        :default => 0
    t.string   "problem_type", :default => "text"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "invite_submissions", :force => true do |t|
    t.integer  "invite_id"
    t.integer  "problem_id"
    t.integer  "submission_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "invites", :force => true do |t|
    t.integer  "user_id"
    t.integer  "collection_id"
    t.string   "candidate_email"
    t.string   "url_hash"
    t.string   "candidate_name"
    t.datetime "start_time"
    t.integer  "score",           :default => 0
    t.boolean  "agree",           :default => false
    t.integer  "candidate_id"
    t.text     "instruction"
    t.boolean  "user_finish",     :default => false
    t.datetime "finish_time"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "problems", :force => true do |t|
    t.string   "name"
    t.text     "statement"
    t.string   "output"
    t.integer  "user_id"
    t.boolean  "reusable",   :default => true
    t.integer  "score",      :default => 3
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "redactor_assets", :force => true do |t|
    t.integer  "user_id"
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "redactor_assets", ["assetable_type", "assetable_id"], :name => "idx_redactor_assetable"
  add_index "redactor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_redactor_assetable_type"

  create_table "submissions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "problem_id"
    t.text     "submission_text"
    t.boolean  "judged"
    t.integer  "score",                                           :default => 0
    t.string   "lang"
    t.string   "problem_type"
    t.string   "status",                                          :default => "Waiting"
    t.text     "compiler_output"
    t.decimal  "execution_time",   :precision => 10, :scale => 0, :default => 0
    t.integer  "submittable_id"
    t.string   "submittable_type"
    t.text     "run_output"
    t.datetime "created_at",                                                             :null => false
    t.datetime "updated_at",                                                             :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name",                                 :default => "",                           :null => false
    t.string   "email",                                :default => "",                           :null => false
    t.string   "organization",                         :default => "",                           :null => false
    t.string   "encrypted_password",                   :default => ""
    t.string   "role",                                 :default => ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                        :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "password_salt"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",                      :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.string   "provider"
    t.string   "providerid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "invitation_token",       :limit => 60
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invite_balance",                       :default => 50
    t.string   "timezone",                             :default => "Eastern Time (US & Canada)"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["invitation_token"], :name => "index_users_on_invitation_token"
  add_index "users", ["invited_by_id"], :name => "index_users_on_invited_by_id"
  add_index "users", ["providerid"], :name => "index_users_on_providerid"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

end
