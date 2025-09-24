class PeriodsController < ApplicationController
  before_action :set_company
  before_action :set_period, only: %i[ show update destroy ]

  # GET /companies/:company_id/periods
  def index
    @periods = @company.periods
    render json: @periods
  end

  # GET /companies/:company_id/periods/1
  def show
    render json: @period
  end

  # POST /companies/:company_id/periods
  def create
    @period = @company.periods.new(period_params)

    if @period.save
      render json: @period, status: :created
    else
      render json: @period.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /companies/:company_id/periods/1
  def update
    if @period.update(period_params)
      render json: @period
    else
      render json: @period.errors, status: :unprocessable_entity
    end
  end

  # DELETE /companies/:company_id/periods/1
  def destroy
    @period.destroy!
  end

  # GET /companies/:company_id/periods/default_period
  def default_period
    period = @company.periods.find_by(status: 'abierto')
    if period
      render json: period
    else
      render json: { error: 'No open period found' }, status: :not_found
    end
  end

  private
    # Set the company from the URL parameter
    def set_company
      @company = Company.find(params[:company_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_period
      @period = @company.periods.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def period_params
      params.require(:period).permit(:name, :status, :period_type, :minimum_score_employee, :formula_above_value, :formula_below_value, :goal_floor, :goal_value, :goal_ceil, :goal_achieved)
    end
end
