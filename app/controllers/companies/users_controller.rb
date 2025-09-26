# frozen_string_literal: true

class Companies::UsersController < ApplicationController
  before_action :set_company
  before_action :set_user, only: [:show, :update, :destroy]

  # GET /companies/:company_id/users
  def index
    @users = @company.users.includes(:company)
    render json: { data: ActiveModel::Serializer::CollectionSerializer.new(@users, serializer: UserSerializer) }
  end

  # GET /companies/:company_id/users/:id
  def show
    render json: { data: UserSerializer.new(@user) }
  end

  # POST /companies/:company_id/users
  def create
    @user = @company.users.build(user_params)
    @user.uid = @user.email  # Set uid to be equal to email
    
    if @user.save
      render json: {
        status: 201,
        message: 'User created successfully.',
        data: UserSerializer.new(@user)
      }, status: :created
    else
      render json: {
        status: 422,
        message: 'User could not be created.',
        errors: @user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /companies/:company_id/users/:id
  def update
    if @user.update(user_update_params)
      render json: {
        status: 200,
        message: 'User updated successfully.',
        data: UserSerializer.new(@user)
      }
    else
      render json: {
        status: 422,
        message: 'User could not be updated.',
        errors: @user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # DELETE /companies/:company_id/users/:id
  def destroy
    if @user.destroy
      render json: {
        status: 200,
        message: 'User deleted successfully.'
      }
    else
      render json: {
        status: 422,
        message: 'User could not be deleted.',
        errors: @user.errors.full_messages
      }, status: :unprocessable_entity
    end
  end



  private

  def set_company
    @company = Company.find(params[:company_id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      status: 404,
      error: 'Not Found',
      message: 'Company not found.'
    }, status: :not_found
  end

  def set_user
    @user = @company.users.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: {
      status: 404,
      error: 'Not Found',
      message: 'User not found in this company.'
    }, status: :not_found
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :name, :nickname, :image)
  end

  def user_update_params
    params.require(:user).permit(:email, :name, :nickname, :image, :password, :password_confirmation)
  end
end
