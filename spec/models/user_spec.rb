# frozen_string_literal: true

# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid with valid attributes' do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end

  it 'is invalid without an email' do
    user = FactoryBot.build(:user, email: nil)
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include("can't be blank")
  end

  it 'is invalid without a username' do
    user = FactoryBot.build(:user, username: nil)
    expect(user).not_to be_valid
    expect(user.errors[:username]).to include("can't be blank")
  end

  it 'is invalid with a short password' do
    user = FactoryBot.build(:user, password: '123')
    expect(user).not_to be_valid
    expect(user.errors[:password]).to include('is too short (minimum is 4 characters)')
  end
end
