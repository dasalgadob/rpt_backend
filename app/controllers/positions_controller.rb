class PositionsController < ApplicationController
  before_action :set_company
  before_action :set_position, only: %i[ show update destroy ]

  # GET /companies/:company_id/positions
  def index
    @positions = @company.positions

    render json: @positions
  end

  # GET /companies/:company_id/positions/1
  def show
    render json: @position
  end

  # POST /companies/:company_id/positions
  def create
    @position = @company.positions.new(position_params)

    if @position.save
      render json: @position, status: :created
    else
      render json: @position.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /companies/:company_id/positions/1
  def update
    if @position.update(position_params)
      render json: @position
    else
      render json: @position.errors, status: :unprocessable_entity
    end
  end

  # DELETE /companies/:company_id/positions/1
  def destroy
    @position.destroy!
  end

  private
    # Set the company from the URL parameter
    def set_company
      @company = Company.find(params[:company_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_position
      @position = @company.positions.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def position_params
      params.require(:position).permit(:name)
    end
end
