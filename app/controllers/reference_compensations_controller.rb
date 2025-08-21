class ReferenceCompensationsController < ApplicationController
  before_action :set_company
  before_action :set_reference_compensation, only: %i[ show update destroy ]

  # GET /companies/:company_id/reference_compensations
  def index
    @reference_compensations = @company.reference_compensations.all
    @reference_compensations = @reference_compensations.where(profit_reference_id: params[:profit_reference_id]) if params[:profit_reference_id].present?

    render json: @reference_compensations
  end

  # GET /companies/:company_id/reference_compensations/1
  def show
    render json: @reference_compensation
  end

  # POST /companies/:company_id/reference_compensations
  def create
    @reference_compensation = @company.reference_compensations.new(reference_compensation_params)

    if @reference_compensation.save
      render json: @reference_compensation, status: :created, location: [@company, @reference_compensation]
    else
      render json: @reference_compensation.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /companies/:company_id/reference_compensations/1
  def update
    if @reference_compensation.update(reference_compensation_params)
      render json: @reference_compensation
    else
      render json: @reference_compensation.errors, status: :unprocessable_entity
    end
  end

  # DELETE /companies/:company_id/reference_compensations/1
  def destroy
    @reference_compensation.destroy!
  end

  private
    # Set the parent company
    def set_company
      @company = Company.find(params[:company_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_reference_compensation
      @reference_compensation = @company.reference_compensations.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def reference_compensation_params
      params.require(:reference_compensation).permit(:profit_reference_id, :percentage, :compensation)
    end
end
