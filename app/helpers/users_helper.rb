# frozen_string_literal: true

# users_helper.rb
module UsersHelper
  def redirect_user_by_role(user)
    redirect_path = choose_redirect_path(user)
    redirect_to redirect_path
  end

  private

  def choose_redirect_path(user)
    case user.role
    when 'admin' then admin_dashboard_index_path
    when 'employee' then dashboard_employees_path
    when 'chef' then dashboard_chefs_path
    else root_path
    end
  end
end
