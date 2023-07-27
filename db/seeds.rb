# frozen_string_literal: true

# db/seeds.rb

# Create admin user
User.create(
  email: 'admin@admin.com',
  password: 'password@123',
  role: 'admin',
  username: 'super_admin',
  name: 'Sangita Adak',
  phone_no: '9044770662'
)

# Sample data for Companies
company1 = Company.create(name: 'Kreeti Technology', address: 'Address', latitude: 22.5730705, longitude: 88.4312256)
company2 = Company.create(name: 'Kaizen', address: 'Address', latitude: 22.5730705, longitude: 88.4312256)
company3 = Company.create(name: 'Fujitsu', address: 'Address', latitude: 22.5730705, longitude: 88.4312256)

# Sample data for FoodStores
food_store1 = FoodStore.create(name: 'Food Store 1', address: 'Address', latitude: 22.5730705, longitude: 88.4312256)
food_store2 = FoodStore.create(name: 'Food Store 2', address: 'Address', latitude: 22.5730705, longitude: 88.4312256)

users_data = [
  { email: 'employee1@gmail.com', password: 'password', role: 'employee', username: 'employee1', name: 'Employee 1',
    phone_no: '1234567890', company_id: company1.id, food_store_id: nil },
  { email: 'chef1@gmail.com', password: 'password', role: 'chef', username: 'chef1', name: 'Chef 1',
    phone_no: '9876543210', company_id: nil, food_store_id: food_store1.id },
  { email: 'employee2@gmail.com', password: 'password', role: 'employee', username: 'employee2', name: 'Employee 2',
    phone_no: '5678901234', company_id: company2.id, food_store_id: nil },
  { email: 'chef2@gmail.com', password: 'password', role: 'chef', username: 'chef2', name: 'Chef 2',
    phone_no: '0123456789', company_id: nil, food_store_id: food_store2.id },
  { email: 'employee3@gmail.com', password: 'password', role: 'employee', username: 'user5', name: 'Employee 3',
    phone_no: '6789012345', company_id: company3.id, food_store_id: nil }
]

users_data.each do |user_params|
  User.create(user_params)
end

food_categories_data = [
  { name: 'Chienese' },
  { name: 'Bengali' },
  { name: 'South Indian' },
  { name: 'Snacks and Bevareges' },
  { name: 'Continental' }
]

food_categories_data.each do |category_params|
  FoodCategory.create(category_params)
end

food_menus_data = [
  # For chef1 who belongs to food_store1
  { user_id: User.find_by(username: 'chef1').id, food_store_id: food_store1.id,
    food_category_id: FoodCategory.first.id, title: 'Egg Chowmin', price: 110 },
  { user_id: User.find_by(username: 'chef1').id, food_store_id: food_store1.id,
    food_category_id: FoodCategory.second.id, title: 'Chicken Momo', price: 110 },

  # For chef2 who belongs to food_store2
  { user_id: User.find_by(username: 'chef2').id, food_store_id: food_store2.id,
    food_category_id: FoodCategory.third.id, title: 'Veg Thali', price: 100 },
  { user_id: User.find_by(username: 'chef2').id, food_store_id: food_store2.id,
    food_category_id: FoodCategory.fourth.id, title: 'Fish Thali', price: 130 }
]

food_menus_data.each do |menu_params|
  FoodMenu.create(menu_params)
end
