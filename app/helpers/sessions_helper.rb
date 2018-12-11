module SessionsHelper
  def log_in admin
    session[:admin_id] = admin.id
  end

  def logged_in?
    current_admin.present?
  end

  def log_out
    forget current_admin
    session.delete :admin_id
    @current_admin = nil
  end

  def current_admin
    if admin_id = session[:admin_id]
      @current_admin ||= Admin.find_by id: admin_id
    end
  end
end
