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
class EmployeeEvaluationSerializer < ActiveModel::Serializer
  attributes :id, :evaluation_score, :corporate_percentage, :department_percentage, :position_percentage, :position_type_weight_info, :corporate_percentage_result, :department_percentage_result, :position_percentage_result, :department_score_result, :position_score_result, :employee
  has_one :employee
  has_one :period

  def employee
    EmployeeSerializer.new(object.employee, scope: scope, root: false)
  end

  def position_type_weight_info
    weight = object.position_type_weight
    return nil unless weight

    {
      id: weight.id,
      corporate_percentage: weight.corporate_percentage,
      department_percentage: weight.department_percentage,
      position_percentage: weight.position_percentage,
      position_type_name: weight.position_type.name
    }
  end

  def corporate_percentage_result
    corporate_score = scope&.dig(:corporate_score)
    return nil unless corporate_score && object.corporate_percentage

    # Calculate: corporate_score * (corporate_percentage / 100)
    (corporate_score * (object.corporate_percentage / 100.0)).round(2)
  end

  def department_percentage_result
    target_period = scope&.dig(:target_period)
    company = scope&.dig(:company)
    return nil unless target_period && company && object.department_percentage && object.employee&.department

    # Calculate department score for this employee's department
    department_score = DepartmentGoal.department_score_for_period(company, target_period, object.employee.department)
    return nil unless department_score

    # Calculate: department_score * (department_percentage / 100)
    (department_score * (object.department_percentage / 100.0)).round(2)
  end

  def position_percentage_result
    target_period = scope&.dig(:target_period)
    return nil unless target_period && object.position_percentage && object.employee

    # Calculate position score for this specific employee
    position_score = PositionGoal.position_score_for_employee(object.employee, target_period)
    return nil unless position_score

    # Calculate: position_score * (position_percentage / 100)
    (position_score * (object.position_percentage / 100.0)).round(2)
  end

  def department_score_result
    target_period = scope&.dig(:target_period)
    company = scope&.dig(:company)
    return nil unless target_period && company && object.employee&.department

    # Return the raw department score for this employee's department
    DepartmentGoal.department_score_for_period(company, target_period, object.employee.department)
  end

  def position_score_result
    target_period = scope&.dig(:target_period)
    return nil unless target_period && object.employee

    # Return the raw position score for this specific employee
    PositionGoal.position_score_for_employee(object.employee, target_period)
  end

  def evaluation_score
    corporate_result = corporate_percentage_result
    department_result = department_percentage_result
    position_result = position_percentage_result

    # Return nil if any of the components are missing
    return nil if corporate_result.nil? || department_result.nil? || position_result.nil?

    # Sum all three percentage results
    (corporate_result + department_result + position_result).round(2)
  end
end
