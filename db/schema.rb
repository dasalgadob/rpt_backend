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

ActiveRecord::Schema[7.1].define(version: 2025_09_08_204637) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "corporate_goals", force: :cascade do |t|
    t.bigint "period_id", null: false
    t.string "description"
    t.decimal "percentage", precision: 5, scale: 2
    t.decimal "score", precision: 5, scale: 2
    t.bigint "dimension_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "goal"
    t.decimal "goal_floor"
    t.decimal "goal_value"
    t.decimal "goal_ceil"
    t.decimal "goal_achieved"
    t.text "formula_below_value"
    t.text "formula_above_value"
    t.index ["dimension_id"], name: "index_corporate_goals_on_dimension_id"
    t.index ["period_id"], name: "index_corporate_goals_on_period_id"
  end

  create_table "department_goals", force: :cascade do |t|
    t.bigint "department_id"
    t.bigint "period_id", null: false
    t.string "description"
    t.decimal "percentage", precision: 5, scale: 2
    t.decimal "score", precision: 5, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "employee_id"
    t.text "goal"
    t.index ["department_id"], name: "index_department_goals_on_department_id"
    t.index ["employee_id"], name: "index_department_goals_on_employee_id"
    t.index ["period_id"], name: "index_department_goals_on_period_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_departments_on_company_id"
  end

  create_table "dimensions", force: :cascade do |t|
    t.string "name"
    t.bigint "period_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["period_id"], name: "index_dimensions_on_period_id"
  end

  create_table "employee_evaluations", force: :cascade do |t|
    t.bigint "employee_id", null: false
    t.bigint "period_id", null: false
    t.string "evaluation_score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "corporate_percentage"
    t.decimal "department_percentage"
    t.decimal "position_percentage"
    t.decimal "job_competencies_score"
    t.decimal "job_competencies_percentage"
    t.index ["employee_id"], name: "index_employee_evaluations_on_employee_id"
    t.index ["period_id"], name: "index_employee_evaluations_on_period_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "employee_id"
    t.string "name"
    t.bigint "department_id", null: false
    t.bigint "position_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "position_id", null: false
    t.index ["department_id"], name: "index_employees_on_department_id"
    t.index ["position_id"], name: "index_employees_on_position_id"
    t.index ["position_type_id"], name: "index_employees_on_position_type_id"
  end

  create_table "periods", force: :cascade do |t|
    t.string "name"
    t.string "status"
    t.string "period_type"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "minimum_score_employee", precision: 5, scale: 2
    t.decimal "company_profit_percentage", precision: 5, scale: 2
    t.decimal "minimum_score_corporate_goals", precision: 5, scale: 2
    t.decimal "minimum_score_area_goals", precision: 5, scale: 2
    t.decimal "minimum_score_position_goals", precision: 5, scale: 2
    t.index ["company_id"], name: "index_periods_on_company_id"
  end

  create_table "position_goals", force: :cascade do |t|
    t.bigint "position_id", null: false
    t.bigint "period_id", null: false
    t.string "description"
    t.decimal "percentage", precision: 5, scale: 2
    t.decimal "score", precision: 5, scale: 2
    t.bigint "department_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "employee_id"
    t.text "goal"
    t.index ["department_id"], name: "index_position_goals_on_department_id"
    t.index ["employee_id"], name: "index_position_goals_on_employee_id"
    t.index ["period_id"], name: "index_position_goals_on_period_id"
    t.index ["position_id"], name: "index_position_goals_on_position_id"
  end

  create_table "position_type_weights", force: :cascade do |t|
    t.bigint "position_type_id", null: false
    t.decimal "corporate_percentage"
    t.decimal "department_percentage"
    t.decimal "position_percentage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "period_id", null: false
    t.decimal "job_competencies_percentage"
    t.index ["period_id"], name: "index_position_type_weights_on_period_id"
    t.index ["position_type_id"], name: "index_position_type_weights_on_position_type_id"
  end

  create_table "position_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id", null: false
    t.index ["company_id"], name: "index_position_types_on_company_id"
  end

  create_table "positions", force: :cascade do |t|
    t.string "name"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_positions_on_company_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_products_on_company_id"
  end

  create_table "profit_reference_has_position_types", force: :cascade do |t|
    t.bigint "profit_reference_id", null: false
    t.bigint "position_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["position_type_id"], name: "index_profit_reference_has_position_types_on_position_type_id"
    t.index ["profit_reference_id"], name: "idx_on_profit_reference_id_ad1ee1ae05"
  end

  create_table "profit_references", force: :cascade do |t|
    t.bigint "period_id", null: false
    t.decimal "since_percentage_profit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "equation"
    t.index ["period_id"], name: "index_profit_references_on_period_id"
  end

  create_table "reference_compensations", force: :cascade do |t|
    t.bigint "profit_reference_id", null: false
    t.decimal "percentage"
    t.decimal "compensation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profit_reference_id"], name: "index_reference_compensations_on_profit_reference_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "nickname"
    t.string "image"
    t.string "email"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "corporate_goals", "dimensions"
  add_foreign_key "corporate_goals", "periods"
  add_foreign_key "department_goals", "departments"
  add_foreign_key "department_goals", "employees"
  add_foreign_key "department_goals", "periods"
  add_foreign_key "departments", "companies"
  add_foreign_key "dimensions", "periods"
  add_foreign_key "employee_evaluations", "employees"
  add_foreign_key "employee_evaluations", "periods"
  add_foreign_key "employees", "departments"
  add_foreign_key "employees", "position_types"
  add_foreign_key "employees", "positions"
  add_foreign_key "periods", "companies"
  add_foreign_key "position_goals", "departments"
  add_foreign_key "position_goals", "employees"
  add_foreign_key "position_goals", "periods"
  add_foreign_key "position_goals", "positions"
  add_foreign_key "position_type_weights", "periods"
  add_foreign_key "position_type_weights", "position_types"
  add_foreign_key "position_types", "companies"
  add_foreign_key "positions", "companies"
  add_foreign_key "products", "companies"
  add_foreign_key "profit_reference_has_position_types", "position_types"
  add_foreign_key "profit_reference_has_position_types", "profit_references"
  add_foreign_key "profit_references", "periods"
  add_foreign_key "reference_compensations", "profit_references"
  add_foreign_key "users", "companies"
end
