class EmployeeEvaluationsDownloadService
  require 'caxlsx'

  def initialize(employee_evaluations, company, corporate_score)
    @employee_evaluations = employee_evaluations
    @company = company
    @corporate_score = corporate_score
  end

  def call
    package = Axlsx::Package.new
    workbook = package.workbook

    workbook.add_worksheet(name: "Employee Evaluations") do |sheet|
      # Add headers
      headers = [
        "ID",
        "Nombre", 
        "Area",
        "Cargo",
        "Tipo de posicion",
        "% Metas Corporativas",
        "Puntuación Metas Corporativas",
        "% Metas de Area",
        "Evaluación de Metas de Area",
        "% Metas Individuales", 
        "Evaluación Metas Individuales",
        "% Competencias",
        "Puntuación competencias",
        "Puntuación Total",
        "Compensación Variable"
      ]
      
      sheet.add_row headers

      # Add data rows
      @employee_evaluations.each do |evaluation|
        employee = evaluation.employee
        position_type_weight = evaluation.position_type_weight
        
        # Calculate the computed values directly instead of using serializer
        corporate_percentage_result = evaluation.corporate_percentage_result
        department_score_result = evaluation.department_score_result(@company)
        position_score_result = evaluation.position_score_result
        department_percentage_result = evaluation.department_percentage_result
        position_percentage_result = evaluation.position_percentage_result
        variable_compensation = evaluation.variable_compensation
        
        row_data = [
          employee.employee_id,
          employee.name,
          employee.department&.name,
          employee.position&.name,
          employee.position_type&.name,
          format_percentage_with_weight(corporate_percentage_result, position_type_weight&.corporate_percentage),
          (@corporate_score&.to_f || 0).round(2),
          format_percentage_with_weight(department_percentage_result, position_type_weight&.department_percentage),
          (department_score_result&.to_f || 0).round(2),
          format_percentage_with_weight(position_percentage_result, position_type_weight&.position_percentage),
          (position_score_result&.to_f || 0).round(2),
          "#{position_type_weight&.job_competencies_percentage || 0}%",
          (evaluation.job_competencies_score&.to_f || 0).round(2),
          (evaluation.evaluation_score&.to_f || 0).round(2),
          (variable_compensation&.to_f || 0).round(2)
        ]
        
        sheet.add_row row_data
      end
    end

    package.to_stream.read
  end

  private

  def format_percentage_with_weight(result_percentage, weight_percentage)
    result = result_percentage&.to_f || 0
    weight = weight_percentage&.to_f || 0
    "#{result}%/#{weight}%"
  end
end
