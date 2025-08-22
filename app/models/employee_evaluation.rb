# == Schema Information
#
# Table name: employee_evaluations
#
#  id                    :bigint           not null, primary key
#  corporate_percentage  :decimal(, )
#  department_percentage :decimal(, )
#  evaluation_score      :string
#  position_percentage   :decimal(, )
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  employee_id           :bigint           not null
#  period_id             :bigint           not null
#
# Indexes
#
#  index_employee_evaluations_on_employee_id  (employee_id)
#  index_employee_evaluations_on_period_id    (period_id)
#
# Foreign Keys
#
#  fk_rails_...  (employee_id => employees.id)
#  fk_rails_...  (period_id => periods.id)
#
class EmployeeEvaluation < ApplicationRecord
  belongs_to :employee
  belongs_to :period

  # Get the position type weight for this evaluation's employee and period
  def position_type_weight
    return nil unless employee.position_type

    PositionTypeWeight.find_by(
      position_type: employee.position_type,
      period: period
    )
  end

  # Calculate variable compensation based on profit reference and evaluation score
  def variable_compensation
    puts "Calculating variable compensation for EmployeeEvaluation ID: #{id}, Employee ID: #{employee.id}, PositionType ID: #{employee.position_type.id}, Period ID: #{period.id}, Company Profit Percentage: #{period.company_profit_percentage}, Evaluation Score: #{evaluation_score(employee.company)}"
    return 0 unless employee.position_type && period.company_profit_percentage && evaluation_score(employee.company)
    # Find the appropriate profit reference for this employee's position type and company profit
    profit_reference = ProfitReference.for_company_profit_and_position_type(
      period,
      period.company_profit_percentage,
      employee.position_type
    )
    puts "Found Profit Reference: #{profit_reference.inspect}" if profit_reference

    return 0 unless profit_reference

    # Use the calculated evaluation_score (method) if possible
    score_percentage = evaluation_score(employee.company).to_f.round(0).to_i rescue evaluation_score.to_f.round(0).to_i
    puts "Score Percentage: #{score_percentage}" if score_percentage
    # Find the matching reference compensation
    reference_compensation = profit_reference.reference_compensations.find_by(percentage: score_percentage)

    return 0 unless reference_compensation

    # Return the compensation amount (assuming there's an amount field)
    reference_compensation.compensation || 0
  end

  # --- Calculation methods moved from serializer ---
  def corporate_percentage_result(company)
    return nil unless company && corporate_percentage && period
    corporate_score = CorporateGoal.corporate_score_for_period(company, period)
    return nil unless corporate_score
    (corporate_score * (corporate_percentage / 100.0)).round(2)
  end

  def department_percentage_result(company)
    return nil unless period && company && department_percentage && employee&.department
    department_score = DepartmentGoal.department_score_for_period(company, period, employee.department)
    return nil unless department_score
    (department_score * (department_percentage / 100.0)).round(2)
  end

  def position_percentage_result
    return nil unless period && position_percentage && employee
    position_score = PositionGoal.position_score_for_employee(employee, period)
    return nil unless position_score
    (position_score * (position_percentage / 100.0)).round(2)
  end

  def department_score_result(company)
    return nil unless period && company && employee&.department
    DepartmentGoal.department_score_for_period(company, period, employee.department)
  end

  def position_score_result
    return nil unless period && employee
    PositionGoal.position_score_for_employee(employee, period)
  end

  def evaluation_score(company)
    corp = corporate_percentage_result(company)
    dept = department_percentage_result(company)
    pos  = position_percentage_result
    return nil if corp.nil? || dept.nil? || pos.nil?
    (corp + dept + pos).round(2)
  end
end
