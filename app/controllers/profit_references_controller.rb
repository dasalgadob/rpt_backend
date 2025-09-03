class ProfitReferencesController < ApplicationController
  before_action :set_company
  before_action :set_profit_reference, only: %i[ show update destroy ]

  # GET /companies/:company_id/profit_references
  def index
    @profit_references = @company.profit_references.all
    @profit_references = @profit_references.where(since_percentage_profit: params[:since_percentage_profit]) if params[:since_percentage_profit].present?

    # Optionally, you can add more filtering based on other parameters
    # e.g., @profit_references = @profit_references.where(period_id: params[:period_id]) if params[:period_id].present?

    render json: @profit_references
  end

  # GET /companies/:company_id/profit_references/1
  def show
    render json: @profit_reference
  end

  # POST /companies/:company_id/profit_references
  def create
    @profit_reference = @company.profit_references.new(profit_reference_params)

    if @profit_reference.save
      create_position_type_associations(@profit_reference, params[:profit_reference][:position_type_ids])
      render json: @profit_reference, status: :created, location: [@company, @profit_reference]
    else
      render json: @profit_reference.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /companies/:company_id/profit_references/1
  def update
    if @profit_reference.update(profit_reference_params)
      # Clear existing associations and create new ones
      @profit_reference.profit_reference_has_position_types.destroy_all if params[:profit_reference][:position_type_ids].present?
      create_position_type_associations(@profit_reference, params[:profit_reference][:position_type_ids])
      render json: @profit_reference
    else
      render json: @profit_reference.errors, status: :unprocessable_entity
    end
  end

  # DELETE /companies/:company_id/profit_references/1
  def destroy
    @profit_reference.destroy!
  end

  private
    # Set the parent company
    def set_company
      @company = Company.find(params[:company_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_profit_reference
      @profit_reference = @company.profit_references.find(params[:id])
    end

    # Create profit_reference_has_position_types associations
    def create_position_type_associations(profit_reference, position_type_ids)
      return unless position_type_ids.present?

      position_type_ids.each do |position_type_id|
        profit_reference.profit_reference_has_position_types.create!(position_type_id: position_type_id)
      end
    end

    # Only allow a list of trusted parameters through.
    def profit_reference_params
      params.require(:profit_reference).permit(:period_id, :since_percentage_profit, :equation)
    end
end
