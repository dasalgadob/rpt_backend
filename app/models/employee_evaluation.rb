# == Schema Information
#
# Table name: employee_evaluations
#
#  id                          :bigint           not null, primary key
#  corporate_percentage        :decimal(, )
#  department_percentage       :decimal(, )
#  evaluation_score            :string
#  job_competencies_percentage :decimal(, )
#  job_competencies_score      :decimal(, )
#  position_percentage         :decimal(, )
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  employee_id                 :bigint           not null
#  period_id                   :bigint           not null
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

  default_scope { joins(:employee).order('employees.name') }

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
    puts "Calculating variable_compensation for EmployeeEvaluation ##{id}"
    # Ensure required data exists
    return 0 unless employee&.position_type && period
    puts "employee position_type_id: #{employee.inspect}"

    # Guard: if any base score < 90.0, return 0
    corporate_score   = CorporateGoal.total_score(period.id)
    department_score  = DepartmentGoal.department_score_for_period(employee)
    position_score    = PositionGoal.position_score_for_employee(employee, period)
    competencies_base = job_competencies_score

    # Compute evaluation score (unrounded) and keep for x
    raw_score = evaluation_score
    puts("🚀 ~ raw_score:", raw_score)
    return 0 if raw_score.nil? || raw_score < 90.0

    # Replace rounded_score with the percentage from CorporateGoal 'Utilidad' for this period
    utilidad_raw = CorporateGoal.find_by(period: period, goal: 'Utilidad')&.score
    return 0 if utilidad_raw.nil?
    # If utilidad score is below 95.0, return 0
    return 0 if utilidad_raw.to_f < 95.0
    # Round to remove decimal part for matching ProfitReference
    utilidad_percentage = utilidad_raw.to_f.round(0)
    puts "utilidad_percentage: #{utilidad_percentage} (raw: #{utilidad_raw})"
    # Find ProfitReference whose since_percentage_profit matches the 'Utilidad' percentage
    # and that is linked to the employee's position_type
    profit_reference = ProfitReference
      .joins(:profit_reference_has_position_types)
      .where(period: period, since_percentage_profit: utilidad_percentage)
      .where(profit_reference_has_position_types: { position_type_id: employee.position_type_id })
      .first
    puts("🚀 ~ profit_reference:", profit_reference)

    return 0 unless profit_reference&.equation.present?

    # Define x as the unrounded evaluation score and evaluate the stored equation
    x = raw_score.to_f / 100
    begin
      puts "x: #{x}"
      puts "equation: #{profit_reference.equation}"
      result = eval(profit_reference.equation, binding)
      # Ensure numeric and round to 2 decimals
      (result.is_a?(Numeric) ? result : result.to_f).round(2)
    rescue StandardError => e
      Rails.logger.error("variable_compensation eval error for EmployeeEvaluation ##{id}: #{e.message}")
      0
    end
  end

  # --- Calculation methods moved from serializer ---
  def corporate_percentage_result
    return nil unless corporate_percentage && period
    corporate_score = CorporateGoal.total_score(period.id)
    pt = employee.position_type
    ptw = PositionTypeWeight.where(period: period, position_type: pt).first
    puts "ptw: #{ptw.corporate_percentage}"
    return nil unless corporate_score
    (corporate_score * (ptw.corporate_percentage / 100.0)).round(2)
  end

  def department_percentage_result
    return nil unless period && employee
    department_score = DepartmentGoal.department_score_for_period(employee)
    puts "department score: #{department_score}"
    pt = employee.position_type
    ptw = PositionTypeWeight.where(period: period, position_type: pt).first
    puts "ptw: #{ptw}"
    return nil unless department_score && ptw
    (department_score * (ptw.department_percentage / 100.0)).round(2)
  end

  def position_percentage_result
    return nil unless period && position_percentage && employee
    position_score = PositionGoal.position_score_for_employee(employee, period)
    pt = employee.position_type
    ptw = PositionTypeWeight.where(period: period, position_type: pt).first
    return 0 unless position_score && ptw
    (position_score * (ptw.position_percentage / 100.0)).round(2)
  end

  def department_score_result(company)
    return 0 unless period && company && employee&.department
    DepartmentGoal.department_score_for_period(employee)
  end

  def position_score_result
    return 0 unless period && employee
    PositionGoal.position_score_for_employee(employee, period)
  end

  def competencies_score_result
    pt = employee.position_type
    ptw = PositionTypeWeight.where(period: period, position_type: pt).first
    return nil unless job_competencies_score && ptw
    (job_competencies_score * (ptw.job_competencies_percentage / 100.0)).round(2)
  end

  def evaluation_score
    corp = corporate_percentage_result || 0
    dept = department_percentage_result || 0
    pos  = position_percentage_result || 0
    competencies = competencies_score_result || 0
    (corp + dept + pos + competencies).round(2)
  end
end
