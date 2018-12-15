class AdminsController < ApplicationController
  def edit
    @admin = Admin.find(params[:id])
  end

  def update
    @admin = Admin.find(params[:id])
    if @admin&.authenticate(params[:admin][:current_password])
      if @admin.update_attributes(params.require(:admin).permit(:password, :password_confirmation))
        flash[:success] = "Change Password Successfully"
        redirect_to @admin
      else
        flash[:error] = "Change Password Failed"
        render :edit
      end
    else
      flash[:error] = "Current Password Invalid"
      render :edit
    end
  end

  private

  def admin_params
    params.require(:admin).permit Admin::ADMIN_ATTRIBUTE
  end
end
