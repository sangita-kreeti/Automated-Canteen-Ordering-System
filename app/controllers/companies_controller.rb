# frozen_string_literal: true

# This is controller
class CompaniesController < ApplicationController
  before_action :authenticate_admin
  def index
    @companies = Company.page(params[:page]).per(15)
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    if @company.save
      redirect_to companies_path, notice: 'Company created successfully.'
    else
      render :new
    end
  end

  def destroy
    @company = Company.find(params[:id])
    @company.destroy
    redirect_to companies_path, notice: 'Company destroyed successfully.'
  end

  private

  def company_params
    params.require(:company).permit(:name, :address, :pincode)
  end
end
