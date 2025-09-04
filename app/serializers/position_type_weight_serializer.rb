# == Schema Information
#
# Table name: position_type_weights
#
#  id                          :bigint           not null, primary key
#  corporate_percentage        :decimal(, )
#  department_percentage       :decimal(, )
#  job_competencies_percentage :decimal(, )
#  position_percentage         :decimal(, )
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  period_id                   :bigint           not null
#  position_type_id            :bigint           not null
#
# Indexes
#
#  index_position_type_weights_on_period_id         (period_id)
#  index_position_type_weights_on_position_type_id  (position_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (period_id => periods.id)
#  fk_rails_...  (position_type_id => position_types.id)
#
class PositionTypeWeightSerializer < ActiveModel::Serializer
  attributes :id, :corporate_percentage, :department_percentage, :position_percentage, :job_competencies_percentage, :position_type_id, :position_type_name, :period_id
  has_one :position_type

  def corporate_percentage
    v = object.corporate_percentage
    v.nil? ? nil : v.to_f.round(2)
  end

  def department_percentage
    v = object.department_percentage
    v.nil? ? nil : v.to_f.round(2)
  end

  def position_percentage
    v = object.position_percentage
    v.nil? ? nil : v.to_f.round(2)
  end

  def job_competencies_percentage
    v = object.job_competencies_percentage
    v.nil? ? nil : v.to_f.round(2)
  end

  def position_type_name
    object.position_type.name if object.position_type
  end

  def period_id
    object.period.id if object.period
  end
end
