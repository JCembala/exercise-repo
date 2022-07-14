# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.create!(
    first_name:'admin',
    last_name:'admin',
    email:'admin@example.com',
    password: 'password',
    password_confirmation: 'password',
    confirmed_at: Time.now.utc,
    admin: true
)

20.times do |i|
    User.create!(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: "user#{i}@example.com",
        password: "password", 
        password_confirmation: "password",
        confirmed_at: Time.now.utc
    )
end

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
