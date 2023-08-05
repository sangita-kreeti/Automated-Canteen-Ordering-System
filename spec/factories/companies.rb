# frozen_string_literal: true

# spec/factories/companies.rb
FactoryBot.define do
  factory :company do
    name { 'Example Company' }
    address { '123 Main Street, City' }
    latitude { 40.7128 }
    longitude { -74.0060 }
  end

  factory :invalid_company, class: 'Company' do
    name { nil }
    address { 'Invalid Address' }
    latitude { nil }
    longitude { nil }
  end
end
