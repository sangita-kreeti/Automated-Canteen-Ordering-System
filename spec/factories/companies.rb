# frozen_string_literal: true

# spec/factories/companies.rb
FactoryBot.define do
  factory :company do
    name { 'Example Company' }
    address { '123 Main Street, City' }
    latitude { 40.7128 } # Example latitude value
    longitude { -74.0060 } # Example longitude value
  end

  factory :invalid_company, class: 'Company' do
    name { nil } # Setting name to nil to trigger the presence validation error
    address { 'Invalid Address' } # Example invalid address
    latitude { nil } # Example invalid latitude value
    longitude { nil } # Example invalid longitude value
  end
end
