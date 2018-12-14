class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    user = User.new(user_params)
    if user.save
      user.store_activation_token
      UserMailer.account_activation(user).deliver_now
      respond_to do |format|
        format.json do
          render json: {
              status: 200,
              message: "Check mail"
          }.to_json
        end
      end
    else
      respond_to do |format|
        format.json do
          render json: {
              status: 500,
              message: "Something went wrong!"
          }.to_json
        end
      end
    end
  end

  def signin
    user = User.find_by username: params[:user][:username]
    if user&.authenticate(params[:user][:password])
      api_key = user.api_key
      if api_key.present?
        respond_to do |format|
          format.json do
            render json: {
                status: 200,
                api_key: api_key,
                message: "Sign in successfully"
            }.to_json
          end
        end
      else
        respond_to do |format|
          format.json do
            render json: {
                status: 500,
                message: "Account not active. Check mail!"
            }.to_json
          end
        end
      end
    else
      respond_to do |format|
        format.json do
          render json: {
              status: 500,
              message: "Something went wrong!"
          }.to_json
        end
      end
    end
  end

  def changepassword
    user = User.find_by(username: params[:user][:username])
    if user&.authenticate(params[:user][:old_password])
      if user.update_attributes(params.require(:user).permit(:password, :password_confirmation))
        respond_to do |format|
          format.json do
            render json: {
                status: 200,
                username: params[:user][:username]
            }.to_json
          end
        end
      else
        respond_to do |format|
          format.json do
            render json: {
                status: 500,
                username: params[:user][:username]
            }.to_json
          end
        end
      end
    else
      respond_to do |format|
        format.json do
          render json: {
              status: 500,
              username: params[:user][:username]
          }.to_json
        end
      end
    end
  end

  def activeAccount
    user = User.find_by email: params[:email]
    activation_token = params[:activation_token]
    if user && user.activation_token == activation_token
      user.store_api_key
      user.store_activation_token
      respond_to do |format|
        format.html do
          render html: "Account activated!"
        end
      end
    else
      respond_to do |format|
        format.html do
          render html: "Link expressed!"
        end
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password,
                                 :password_confirmation)
  end

end