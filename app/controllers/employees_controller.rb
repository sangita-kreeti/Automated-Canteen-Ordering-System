# frozen_string_literal: true

# This is a controller
class EmployeesController < ApplicationController
  before_action :authenticate_admin, except: [:dashboard]
  before_action :authenticate_employee, only: [:dashboard]

  def select; end

  def all_employees
    @employees = User.employees_by_type(params[:employee_type]).page(params[:page]).per(15)
  end
  

  def approved
    employee = find_employee_by_id
    return unless employee.update(approved: true)

    admin = current_user
    unless employee.hide_notifications
      Notification.create_employee_approved_notification(admin, employee,
                                                         'You have been successfully approved by an admin.')
    end
    notice_message = 'Employee approved successfully.'
    
    redirect_path = employee.company_id.zero? ? all_employees_employees_path(employee_type: 'ordinary') : all_employees_employees_path(employee_type: 'company')
    redirect_to redirect_path, notice: notice_message

  end

  def reject
    employee = find_employee_by_id
    employee.destroy
    if employee.company_id.zero?
      redirect_to ordinary_employees_employees_path, notice: 'Employee rejected and removed.'
    else
      redirect_to company_employees_path, notice: 'Employee rejected and removed.'
    end
  end

  def dashboard
    @notifications = current_user.notifications.order(created_at: :desc)
  end

  def manage_notifications
    @employees = User.employees.page(params[:page]).per(15)
  end

  def update_notifications
    employee = User.find(params[:id])

    if employee.hide_notifications?
      if employee.update(hide_notifications: false)
        redirect_to manage_notifications_employees_path, notice: 'Notifications shown for the employee.'
      end
    elsif employee.update(hide_notifications: true)
      redirect_to manage_notifications_employees_path, notice: 'Notifications hidden for the employee.'
    end
  end

  private

  def find_employee_by_id
    User.find(params[:id])
  end
end
