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

ActiveRecord::Schema.define(version: 20150820133107) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "history_accounts", id: false, force: :cascade do |t|
    t.integer "id",      limit: 8,  null: false
    t.string  "address", limit: 64
  end

  add_index "history_accounts", ["id"], name: "index_history_accounts_on_id", unique: true, using: :btree

  create_table "history_effects", id: false, force: :cascade do |t|
    t.integer "history_account_id",   limit: 8, null: false
    t.integer "history_operation_id", limit: 8, null: false
    t.integer "order",                          null: false
    t.integer "type",                           null: false
    t.jsonb   "details"
  end

  add_index "history_effects", ["history_account_id", "history_operation_id", "order"], name: "hist_e_id", unique: true, using: :btree
  add_index "history_effects", ["history_operation_id", "order"], name: "hist_e_by_order", unique: true, using: :btree
  add_index "history_effects", ["type"], name: "index_history_effects_on_type", using: :btree

  create_table "history_ledgers", id: false, force: :cascade do |t|
    t.integer  "sequence",                                    null: false
    t.string   "ledger_hash",          limit: 64,             null: false
    t.string   "previous_ledger_hash", limit: 64
    t.integer  "transaction_count",               default: 0, null: false
    t.integer  "operation_count",                 default: 0, null: false
    t.datetime "closed_at",                                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "id",                   limit: 8
  end

  add_index "history_ledgers", ["closed_at"], name: "index_history_ledgers_on_closed_at", using: :btree
  add_index "history_ledgers", ["id"], name: "hs_ledger_by_id", unique: true, using: :btree
  add_index "history_ledgers", ["id"], name: "index_history_ledgers_on_id", unique: true, using: :btree
  add_index "history_ledgers", ["ledger_hash"], name: "index_history_ledgers_on_ledger_hash", unique: true, using: :btree
  add_index "history_ledgers", ["previous_ledger_hash"], name: "index_history_ledgers_on_previous_ledger_hash", unique: true, using: :btree
  add_index "history_ledgers", ["sequence"], name: "index_history_ledgers_on_sequence", unique: true, using: :btree

  create_table "history_operation_participants", force: :cascade do |t|
    t.integer "history_operation_id", limit: 8, null: false
    t.integer "history_account_id",   limit: 8, null: false
  end

  add_index "history_operation_participants", ["history_account_id", "history_operation_id"], name: "hist_op_p_id", unique: true, using: :btree

  create_table "history_operations", id: false, force: :cascade do |t|
    t.integer "id",                limit: 8, null: false
    t.integer "transaction_id",    limit: 8, null: false
    t.integer "application_order",           null: false
    t.integer "type",                        null: false
    t.jsonb   "details"
  end

  add_index "history_operations", ["id"], name: "index_history_operations_on_id", unique: true, using: :btree
  add_index "history_operations", ["transaction_id"], name: "index_history_operations_on_transaction_id", using: :btree
  add_index "history_operations", ["type"], name: "index_history_operations_on_type", using: :btree

  create_table "history_transaction_participants", force: :cascade do |t|
    t.string   "transaction_hash", limit: 64, null: false
    t.string   "account",          limit: 64, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "history_transaction_participants", ["account"], name: "index_history_transaction_participants_on_account", using: :btree
  add_index "history_transaction_participants", ["transaction_hash"], name: "index_history_transaction_participants_on_transaction_hash", using: :btree

  create_table "history_transaction_statuses", force: :cascade do |t|
    t.string  "result_code_s", null: false
    t.integer "result_code",   null: false
  end

  add_index "history_transaction_statuses", ["id", "result_code", "result_code_s"], name: "index_history_transaction_statuses_lc_on_all", unique: true, using: :btree

  create_table "history_transactions", id: false, force: :cascade do |t|
    t.string   "transaction_hash",      limit: 64, null: false
    t.integer  "ledger_sequence",                  null: false
    t.integer  "application_order",                null: false
    t.string   "account",               limit: 64, null: false
    t.integer  "account_sequence",      limit: 8,  null: false
    t.integer  "max_fee",                          null: false
    t.integer  "fee_paid",                         null: false
    t.integer  "operation_count",                  null: false
    t.integer  "transaction_status_id",            null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "id",                    limit: 8
    t.string   "txresult"
    t.boolean  "success"
  end

  add_index "history_transactions", ["account", "account_sequence"], name: "by_account", using: :btree
  add_index "history_transactions", ["id"], name: "hs_transaction_by_id", unique: true, using: :btree
  add_index "history_transactions", ["id"], name: "index_history_transactions_on_id", unique: true, using: :btree
  add_index "history_transactions", ["ledger_sequence", "application_order"], name: "by_ledger", using: :btree
  add_index "history_transactions", ["transaction_hash"], name: "by_hash", using: :btree
  add_index "history_transactions", ["transaction_status_id"], name: "by_status", using: :btree

end
