# Users
User.create!(
  name: "Huynh Thanh Chuc",
  email: "thanhchuc.cnttk38@gmail.com",
  address: "Đà Nẵng",
  phone: "0924261996",
  role: 1,
  password: "123456",
  password_confirmation: "123456"
)

10.times do |n|
  User.create!(
    name: Faker::Name.name,
    email: "example#{n+1}@gmail.com",
    password: "123456",
    password_confirmation: "123456",
    address: Faker::Address.full_address,
    phone: Faker::Number.leading_zero_number(digits: 10),
    role: 0)
  end

users = User.all
users.each do |user|
  user.image.attach(
    io: File.open('/home/chucht96/Desktop/dn_oe44_ruby-food-and-drink/app/assets/images/user.png'),
    filename: 'user.png'
  )
end


# Categories
Category.create!(name: "Foods")
Category.create!(name: "Drinks")

# Products
categories = Category.all
categories.each do |category|
  10.times do |n|
    category.products.create!(
      name: category.name + " #{n+1}",
      infor: Faker::Lorem.paragraph,
      quantity: Faker::Number.non_zero_digit,
      price: Faker::Number.decimal(l_digits: 2),
      )
  end
end

products = Product.all
products.each do |product|
  product.images.attach(
    io: File.open('/home/chucht96/Desktop/dn_oe44_ruby-food-and-drink/app/assets/images/food.jpg'),
    filename: 'food.jpg'
  )
end

# Orders
10.times do |n|
  Order.create!(
    user_id: User.limit(3).pluck(:id).sample,
    status: Order.statuses.values.sample,
    total: 1000
  )
end

#Order Details
20.times do |n|
  OrderDetail.create!(
    order_id: Order.pluck(:id).sample,
    product_id: Product.pluck(:id).sample,
    current_price: Faker::Number.decimal(l_digits: 2),
    quantity: rand(1..10)
  )
end
