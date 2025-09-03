# == Schema Information
#
# Table name: profit_references
#
#  id                      :bigint           not null, primary key
#  equation                :text
#  since_percentage_profit :decimal(, )
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  period_id               :bigint           not null
#
# Indexes
#
#  index_profit_references_on_period_id  (period_id)
#
# Foreign Keys
#
#  fk_rails_...  (period_id => periods.id)
#
class ProfitReference < ApplicationRecord
  default_scope { order(since_percentage_profit: :asc) }
  belongs_to :period
  has_many :profit_reference_has_position_types, dependent: :destroy
  has_many :position_types, through: :profit_reference_has_position_types
  has_many :reference_compensations, dependent: :destroy
  
  accepts_nested_attributes_for :profit_reference_has_position_types, allow_destroy: true

  # Check if this profit reference has a specific position type
  def has_position_type?(position_type)
    position_types.include?(position_type)
  end

  # Find the appropriate profit reference for a given company profit percentage and position type
  # Logic: 
  # - Range is from since_percentage_profit (inclusive) to next higher value (exclusive)
  # - Highest value includes everything >= its since_percentage_profit
  def self.for_company_profit_and_position_type(period, company_profit_percentage, position_type)
    # Get all profit references for the period that have the position type
    references_with_position = joins(:profit_reference_has_position_types)
                              .joins(:position_types)
                              .where(period: period)
                              .where(position_types: { id: position_type.id })
                              .distinct
                              .order(:since_percentage_profit)

    return nil if references_with_position.empty?

    # Find the appropriate reference based on company profit percentage
    references_array = references_with_position.to_a
    
    # If only one reference, use it if company profit >= its threshold
    if references_array.length == 1
      return references_array.first if company_profit_percentage >= references_array.first.since_percentage_profit
      return nil
    end

    # Multiple references - find the correct range
    references_array.each_with_index do |reference, index|
      current_threshold = reference.since_percentage_profit
      
      # If this is the last (highest) reference
      if index == references_array.length - 1
        return reference if company_profit_percentage >= current_threshold
      else
        # Check if company profit falls in this range
        next_threshold = references_array[index + 1].since_percentage_profit
        if company_profit_percentage >= current_threshold && company_profit_percentage < next_threshold
          return reference
        end
      end
    end

    # If company profit is below the lowest threshold, return nil
    nil
  end

  # Alternative method that returns the reference for any position type (not filtered by position type)
  def self.for_company_profit(period, company_profit_percentage)
    references = where(period: period).order(:since_percentage_profit)
    
    return nil if references.empty?

    references_array = references.to_a
    
    if references_array.length == 1
      return references_array.first if company_profit_percentage >= references_array.first.since_percentage_profit
      return nil
    end

    references_array.each_with_index do |reference, index|
      current_threshold = reference.since_percentage_profit
      
      if index == references_array.length - 1
        return reference if company_profit_percentage >= current_threshold
      else
        next_threshold = references_array[index + 1].since_percentage_profit
        if company_profit_percentage >= current_threshold && company_profit_percentage < next_threshold
          return reference
        end
      end
    end

    nil
  end
end
