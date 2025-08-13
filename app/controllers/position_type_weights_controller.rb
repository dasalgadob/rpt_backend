class PositionTypeWeightsController < ApplicationController
  before_action :set_company
  before_action :set_position_type_weight, only: %i[ show update destroy ]

  # GET /companies/:company_id/position_type_weights
  def index
    @position_type_weights = @company.position_type_weights

    render json: @position_type_weights
  end

  # GET /companies/:company_id/position_type_weights/1
  def show
    render json: @position_type_weight
  end

  # POST /companies/:company_id/position_type_weights
  def create
    @position_type_weight = @company.position_type_weights.new(position_type_weight_params)

    if @position_type_weight.save
      render json: @position_type_weight, status: :created
    else
      render json: @position_type_weight.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /companies/:company_id/position_type_weights/1
  def update
    if @position_type_weight.update(position_type_weight_params)
      render json: @position_type_weight
    else
      render json: @position_type_weight.errors, status: :unprocessable_entity
    end
  end

  # DELETE /companies/:company_id/position_type_weights/1
  def destroy
    @position_type_weight.destroy!
  end

  private
    # Set the company from the URL parameter
    def set_company
      @company = Company.find(params[:company_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_position_type_weight
      @position_type_weight = @company.position_type_weights.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def position_type_weight_params
      params.require(:position_type_weight).permit(:position_type_id, :corporate_percentage, :department_percentage, :position_percentage)
    end
end
