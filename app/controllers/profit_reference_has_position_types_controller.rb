class ProfitReferenceHasPositionTypesController < ApplicationController
  before_action :set_company
  before_action :set_profit_reference_has_position_type, only: %i[ show update destroy ]

  # GET /companies/:company_id/profit_reference_has_position_types
  def index
    @profit_reference_has_position_types = @company.profit_reference_has_position_types.all

    render json: @profit_reference_has_position_types
  end

  # GET /companies/:company_id/profit_reference_has_position_types/1
  def show
    render json: @profit_reference_has_position_type
  end

  # POST /companies/:company_id/profit_reference_has_position_types
  def create
    @profit_reference_has_position_type = @company.profit_reference_has_position_types.new(profit_reference_has_position_type_params)

    if @profit_reference_has_position_type.save
      render json: @profit_reference_has_position_type, status: :created, location: [@company, @profit_reference_has_position_type]
    else
      render json: @profit_reference_has_position_type.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /companies/:company_id/profit_reference_has_position_types/1
  def update
    if @profit_reference_has_position_type.update(profit_reference_has_position_type_params)
      render json: @profit_reference_has_position_type
    else
      render json: @profit_reference_has_position_type.errors, status: :unprocessable_entity
    end
  end

  # DELETE /companies/:company_id/profit_reference_has_position_types/1
  def destroy
    @profit_reference_has_position_type.destroy!
  end

  private
    # Set the parent company
    def set_company
      @company = Company.find(params[:company_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_profit_reference_has_position_type
      @profit_reference_has_position_type = @company.profit_reference_has_position_types.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def profit_reference_has_position_type_params
      params.require(:profit_reference_has_position_type).permit(:profit_reference_id, :position_type_id)
    end
end
