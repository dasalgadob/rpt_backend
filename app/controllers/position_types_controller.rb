class PositionTypesController < ApplicationController
  before_action :set_position_type, only: %i[ show update destroy ]

  # GET /position_types
  def index
    @position_types = PositionType.all

    render json: @position_types
  end

  # GET /position_types/1
  def show
    render json: @position_type
  end

  # POST /position_types
  def create
    @position_type = PositionType.new(position_type_params)

    if @position_type.save
      render json: @position_type, status: :created, location: @position_type
    else
      render json: @position_type.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /position_types/1
  def update
    if @position_type.update(position_type_params)
      render json: @position_type
    else
      render json: @position_type.errors, status: :unprocessable_entity
    end
  end

  # DELETE /position_types/1
  def destroy
    @position_type.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_position_type
      @position_type = PositionType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def position_type_params
      params.require(:position_type).permit(:name)
    end
end
