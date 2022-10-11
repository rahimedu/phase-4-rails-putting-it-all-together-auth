class SessionsController < ApplicationController

    def create
      user = User.find_by!(username: params[:username])
      if user
        if user.authenticate(params[:password])
          session[:user_id] = user.id
          render json: user, status: :created
        else
          # byebug
          render json: {errors: user.errors.full_messages}, status: :unauthorized
        end
      end
    rescue ActiveRecord::RecordNotFound => e
      # byebug
      render json: { errors: [] }, status: :unauthorized
    end
  
    def destroy
      if session[:user_id]
        session.delete :user_id
        head :no_content
      else
        render json: { errors: []}, status: :unauthorized
      end
    end
  end