class UsersController < ApplicationController

    def create
      # byebug
      user = User.new(user_params)
      if user.valid? && params[:password] == params[:password_confirmation]
        user.save!
        session[:user_id] = user.id
        render json: user, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def show
      if session[:user_id]
        user = User.find(session[:user_id])
        render json: user
      else
        render json: { error: "Not authorized" }, status: :unauthorized
      end
    end
  
    private
  
    def user_params
      params.permit(:username, :password, :password_confirmation, :password_digest, :image_url, :bio)
    end
  end