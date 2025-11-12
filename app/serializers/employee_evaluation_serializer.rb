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
class EmployeeEvaluationSerializer < ActiveModel::Serializer
  attributes :id, :evaluation_score, :corporate_percentage, :department_percentage, :position_percentage, :job_competencies_score, :position_type_weight_info, :corporate_percentage_result, :department_percentage_result, :position_percentage_result, :job_competencies_percentage_result, :personal_percentage, :department_score_result, :position_score_result, :employee, :variable_compensation, :total_variable_compensation
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
      position_type_name: weight.position_type.name,
      job_competencies_percentage: weight.job_competencies_percentage
    }
  end

  def corporate_percentage_result
    object.corporate_percentage_result
  end

  def department_percentage_result
    object.department_percentage_result
  end

  def position_percentage_result
    object.position_percentage_result
  end

  def job_competencies_percentage_result
    object.job_competencies_percentage_result
  end

  def personal_percentage
    object.personal_percentage
  end

  def department_score_result
    object.department_score_result(scope&.dig(:company))
  end

  def position_score_result
    object.position_score_result
  end

  def evaluation_score
    object.evaluation_score
  end

  def total_variable_compensation
    object.total_variable_compensation
  end
end
