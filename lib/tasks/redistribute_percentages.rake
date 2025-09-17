namespace :goals do
  desc "Redistribute percentage values for department and position goals to sum to 100%"
  task redistribute_percentages: :environment do
    puts "Starting percentage redistribution..."
    
    department_goals_updated = 0
    position_goals_updated = 0
    employees_processed = 0
    
    # Get all employees with goals
    employees_with_goals = Employee.joins("LEFT JOIN department_goals ON employees.id = department_goals.employee_id")
                                  .joins("LEFT JOIN position_goals ON employees.id = position_goals.employee_id")
                                  .where("department_goals.id IS NOT NULL OR position_goals.id IS NOT NULL")
                                  .distinct
    
    employees_with_goals.each do |employee|
      employees_processed += 1
      puts "Processing employee: #{employee.name} (ID: #{employee.id})"
      
      # Process department goals for this employee
      department_goals = DepartmentGoal.where(employee: employee)
      if department_goals.any?
        total_dept_percentage = department_goals.sum(:percentage)
        
        if total_dept_percentage > 0 && total_dept_percentage != 100
          puts "  Department goals total: #{total_dept_percentage}% - redistributing..."
          
          department_goals.each do |goal|
            original_percentage = goal.percentage
            # Calculate new percentage: (original / total) * 100
            new_percentage = ((original_percentage / total_dept_percentage) * 100).round(2)
            goal.update!(percentage: new_percentage)
            
            puts "    Goal ID #{goal.id}: #{original_percentage}% → #{new_percentage}%"
            department_goals_updated += 1
          end
        else
          puts "  Department goals total: #{total_dept_percentage}% - no changes needed"
        end
      end
      
      # Process position goals for this employee
      position_goals = PositionGoal.where(employee: employee)
      if position_goals.any?
        total_pos_percentage = position_goals.sum(:percentage)
        
        if total_pos_percentage > 0 && total_pos_percentage != 100
          puts "  Position goals total: #{total_pos_percentage}% - redistributing..."
          
          position_goals.each do |goal|
            original_percentage = goal.percentage
            # Calculate new percentage: (original / total) * 100
            new_percentage = ((original_percentage / total_pos_percentage) * 100).round(2)
            goal.update!(percentage: new_percentage)
            
            puts "    Goal ID #{goal.id}: #{original_percentage}% → #{new_percentage}%"
            position_goals_updated += 1
          end
        else
          puts "  Position goals total: #{total_pos_percentage}% - no changes needed"
        end
      end
      
      puts "  ---"
    end
    
    puts "\n=== Redistribution Summary ==="
    puts "Employees processed: #{employees_processed}"
    puts "Department goals updated: #{department_goals_updated}"
    puts "Position goals updated: #{position_goals_updated}"
    puts "Total goals updated: #{department_goals_updated + position_goals_updated}"
    puts "Redistribution complete!"
  end
end
