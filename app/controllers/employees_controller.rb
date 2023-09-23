# frozen_string_literal: true

# This is a controller
class EmployeesController < ApplicationController
  before_action :authenticate_admin

  def select_employees; end

  def company_employees
    @employees = User.where(role: 'employee').where.not(company_id: 0).page(params[:page]).per(15)
  end

  def ordinary_employees
    @employees = User.where(role: 'employee', company_id: 0).page(params[:page]).per(15)
  end

  def approved
    employee = find_employee_by_id

    if employee.update(approved: true)
      admin = current_user
      unless employee.hide_notifications
        Notification.create_employee_approved_notification(admin, employee,
                                                           'You have been successfully approved by an admin.')
      end

      notice_message = 'Employee approved successfully.'
      redirect_path = employee.company_id.zero? ? ordinary_employees_path : company_employees_path
      redirect_to redirect_path, notice: notice_message
    else
      error_messages = employee.errors.full_messages.join(', ')
      redirect_to admin_dashboard_path, alert: "Failed to approve the employee: #{error_messages}"
    end
  end

  def reject
    employee = find_employee_by_id
    employee.destroy
    if employee.company_id.zero?
      redirect_to ordinary_employees_path, notice: 'Employee rejected and removed.'
    else
      redirect_to company_employees_path, notice: 'Employee rejected and removed.'
    end
  end

  def manage_notifications
    @employees = User.where(role: 'employee').page(params[:page]).per(15)
  end

  def update_notifications
    employee = User.find(params[:id])

    if employee.hide_notifications?
      if employee.update(hide_notifications: false)
        redirect_to manage_notifications_employee_path, notice: 'Notifications shown for the employee.'
      end
    elsif employee.update(hide_notifications: true)
      redirect_to manage_notifications_employee_path, notice: 'Notifications hidden for the employee.'
    end
  end

  private

  def find_employee_by_id
    User.find(params[:id])
  end
end
