# frozen_string_literal: true

# This is a controller
class EmployeesController < ApplicationController
  before_action :authenticate_user
  def index
    @employees = User.where(role: 'employee').page(params[:page]).per(15)
  end

  def approved
    employee = find_employee_by_id
    if employee.update(approved: true)
      admin = current_user
      unless employee.hide_notifications
        Notification.create_employee_approved_notification(admin, employee, 'Employee approved successfully.')
      end
      redirect_to employees_path, notice: 'Employee approved successfully.'
    else
      redirect_to employees_path, alert: 'Failed to approve the employee.'
    end
  end

  def reject
    employee = find_employee_by_id
    employee.destroy
    redirect_to employees_path, alert: 'Employee rejected and removed.'
  end

  def manage_notifications
    @employees = User.where(role: 'employee').page(params[:page]).per(15)
  end

  def update_notifications
    employee = User.find(params[:id])
    if employee.update(hide_notifications: true)
      redirect_to manage_notifications_employee_path, notice: 'Notification hidden for the employee.'
    else
      redirect_to manage_notifications_employee_path, alert: 'Failed to hide notifications for the employee.'
    end
  end

  private

  def find_employee_by_id
    User.find(params[:id])
  end
end
