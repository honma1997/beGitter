# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Admin.find_or_create_by!(email: "admin@gmail.com") do |admin|
  admin.password = "123456"
  admin.password_confirmation = "123456"
end

# ユーザー5人作成
5.times do |i|
  user = User.create!(
    email: "user#{i + 1}@example.com",
    password: "password",
    name: "ユーザー#{i + 1}"
  )

  # 各ユーザーに3つの投稿を作成
  3.times do |j|
    user.posts.create!(
      title: "ユーザー#{i + 1}の投稿#{j + 1}",
      body: "これはユーザー#{i + 1}の#{j + 1}番目の投稿です。"
    )
  end
end