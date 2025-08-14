class EmployeeEvaluationsController < ApplicationController
  before_action :set_employee_evaluation, only: %i[ show update destroy ]

  # GET /employee_evaluations
  def index
    @employee_evaluations = EmployeeEvaluation.all

    render json: @employee_evaluations
  end

  # GET /employee_evaluations/1
  def show
    render json: @employee_evaluation
  end

  # POST /employee_evaluations
  def create
    @employee_evaluation = EmployeeEvaluation.new(employee_evaluation_params)

    if @employee_evaluation.save
      render json: @employee_evaluation, status: :created, location: @employee_evaluation
    else
      render json: @employee_evaluation.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /employee_evaluations/1
  def update
    if @employee_evaluation.update(employee_evaluation_params)
      render json: @employee_evaluation
    else
      render json: @employee_evaluation.errors, status: :unprocessable_entity
    end
  end

  # DELETE /employee_evaluations/1
  def destroy
    @employee_evaluation.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee_evaluation
      @employee_evaluation = EmployeeEvaluation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def employee_evaluation_params
      params.require(:employee_evaluation).permit(:employee_id, :period_id, :evaluation_score)
    end
end
