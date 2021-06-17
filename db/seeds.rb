# Categories
Category.create!(name: "Foods")
Category.create!(name: "Drinks")

# Products
categories = Category.all
categories.each do |category|
  10.times do |n|
    Product.create!(
      name: category.name + " #{n+1}",
      infor: Faker::Lorem.paragraph,
      quantity: Faker::Number.non_zero_digit,
      price: Faker::Number.decimal(l_digits: 2),
      )
  end
end

# Images
products = Product.all
products.each do |product|
  product.images.attach(
    io: File.open('/home/chucht96/Desktop/dn_oe44_ruby-food-and-drink/app/assets/images/food.jpeg'),
    filename: 'food.jpeg'
  )
end
