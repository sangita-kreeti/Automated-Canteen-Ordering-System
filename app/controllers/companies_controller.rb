# frozen_string_literal: true

# This is controller
class CompaniesController < ApplicationController
  before_action :authenticate_user
  def index
    @companies = Company.page(params[:page]).per(15)
  end

  def show
    @company = Company.find(params[:id])
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)

    if @company.save
      redirect_to companies_path, notice: 'Company was successfully created.'
    else
      render :new
    end
  end

  def edit
    @company = Company.find(params[:id])
  end

  def update
    @company = Company.find(params[:id])

    if @company.update(company_params)
      redirect_to companies_path, notice: 'Company was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @company = Company.find(params[:id])
    @company.destroy
    redirect_to companies_path, notice: 'Company was successfully destroyed.'
  end

  private

  def company_params
    params.require(:company).permit(:name, :address, :latitude, :longitude)
  end
end
