class SessionsController < ApplicationController
  def new
    if current_admin.present?
      redirect_to users_url
    end
  end

  def create
    admin = Admin.find_by name: params[:session][:name]
    if admin&.authenticate(params[:session][:password])
      log_in admin
      redirect_to users_url
    else
      flash.now[:danger] = t "login_error"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
