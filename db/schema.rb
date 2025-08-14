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

ActiveRecord::Schema[7.1].define(version: 2025_08_13_205001) do
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
    t.index ["dimension_id"], name: "index_corporate_goals_on_dimension_id"
    t.index ["period_id"], name: "index_corporate_goals_on_period_id"
  end

  create_table "department_goals", force: :cascade do |t|
    t.bigint "department_id", null: false
    t.bigint "period_id", null: false
    t.string "description"
    t.decimal "percentage", precision: 5, scale: 2
    t.decimal "score", precision: 5, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_department_goals_on_department_id"
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
    t.index ["employee_id"], name: "index_employee_evaluations_on_employee_id"
    t.index ["period_id"], name: "index_employee_evaluations_on_period_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "employee_id"
    t.string "name"
    t.bigint "department_id", null: false
    t.bigint "position_type_id", null: false
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
    t.index ["department_id"], name: "index_position_goals_on_department_id"
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

  add_foreign_key "corporate_goals", "dimensions"
  add_foreign_key "corporate_goals", "periods"
  add_foreign_key "department_goals", "departments"
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
  add_foreign_key "position_goals", "periods"
  add_foreign_key "position_goals", "positions"
  add_foreign_key "position_type_weights", "periods"
  add_foreign_key "position_type_weights", "position_types"
  add_foreign_key "position_types", "companies"
  add_foreign_key "positions", "companies"
  add_foreign_key "products", "companies"
end
