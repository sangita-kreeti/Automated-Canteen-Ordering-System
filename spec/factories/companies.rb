# frozen_string_literal: true

# spec/factories/companies.rb
FactoryBot.define do
  factory :company do
    name { 'Example Company' }
    address { '123 Main Street, City' }
    pincode { 700_091 }
  end

  factory :invalid_company, class: 'Company' do
    name { nil }
    address { 'Invalid Address' }
    pincode { nil }
  end
end
