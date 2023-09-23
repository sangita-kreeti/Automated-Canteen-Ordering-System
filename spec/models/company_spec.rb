# frozen_string_literal: true

# spec/models/company_spec.rb

require 'rails_helper'
# rubocop:disable Metrics/BlockLength
RSpec.describe Company, type: :model do
  context 'validations' do
    it 'is valid with valid attributes' do
      company = Company.new(
        name: 'Example Company',
        address: '123 Main Street, City',
        pincode: 700_091
      )
      expect(company).to be_valid
    end

    it 'is invalid without a name' do
      company = Company.new(
        address: '123 Main Street, City',
        pincode: 700_091
      )
      expect(company).not_to be_valid
      expect(company.errors[:name]).to include("can't be blank")
    end

    it 'is invalid without an address' do
      company = Company.new(
        name: 'Example Company',
        pincode: 700_091
      )
      expect(company).not_to be_valid
      expect(company.errors[:address]).to include("can't be blank")
    end

    it 'is invalid without a longitude' do
      company = Company.new(
        name: 'Example Company',
        address: '123 Main Street, City'
      )
      expect(company).not_to be_valid
      expect(company.errors[:pincode]).to include("can't be blank")
    end
  end
end
# rubocop:enable Metrics/BlockLength
