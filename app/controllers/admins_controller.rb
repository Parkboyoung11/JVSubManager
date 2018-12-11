class AdminsController < ApplicationController
  def create
    @admin = Admin.new admin_params
    if @admin.save
      flash[:success] = t "Welcome"
      redirect_to root_url
    else
      flash[:danger] = t "error"
      redirect_to root_url
    end
  end

  def show
    @admin = Admin.find_by id: params[:id]

    return if @admin
    flash[:success] = t "error"
    redirect_to root_url
  end

  private

  def admin_params
    params.require(:admin).permit Admin::ADMIN_ATTRIBUTE
  end
end
