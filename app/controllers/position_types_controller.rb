class PositionTypesController < ApplicationController
  before_action :set_company
  before_action :set_position_type, only: %i[ show update destroy ]

  # GET /companies/:company_id/position_types
  def index
    @position_types = @company.position_types

    render json: @position_types
  end

  # GET /companies/:company_id/position_types/1
  def show
    render json: @position_type
  end

  # POST /companies/:company_id/position_types
  def create
    @position_type = @company.position_types.new(position_type_params)

    if @position_type.save
      render json: @position_type, status: :created
    else
      render json: @position_type.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /companies/:company_id/position_types/1
  def update
    if @position_type.update(position_type_params)
      render json: @position_type
    else
      render json: @position_type.errors, status: :unprocessable_entity
    end
  end

  # DELETE /companies/:company_id/position_types/1
  def destroy
    @position_type.destroy!
  end

  private
    # Set the company from the URL parameter
    def set_company
      @company = Company.find(params[:company_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_position_type
      @position_type = @company.position_types.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def position_type_params
      params.require(:position_type).permit(:name)
    end
end
