# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Follow.destroy_all
Post.destroy_all
User.destroy_all

# Creating admin
User.create!(
    first_name:'admin',
    last_name:'admin',
    email:'admin@example.com',
    password: 'password',
    password_confirmation: 'password',
    confirmed_at: Time.now.utc,
    admin: true
)

# Creating users
20.times do |i|
    u = User.create!(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: "user#{i}@example.com",
        password: "password", 
        password_confirmation: "password",
        confirmed_at: Time.now.utc
    )

    Post.create!(
        title: "#{u.first_name} #{u.last_name} post",
        content: Faker::Lorem.paragraph,
        user_id: u.id
    )
end

# Creating archived users
10.times do |i|
    User.create!(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: "user#{i+20}@example.com",
        password: "password", 
        password_confirmation: "password",
        confirmed_at: Time.now.utc,
        archived_at: Time.now.utc
    )
end

