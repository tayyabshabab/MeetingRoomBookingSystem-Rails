namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(name: "Tayyab Shabab",
                 email: "tayyabshabab@gmail.com",
                 password: "test123",
                 password_confirmation: "test123",
                 admin: true)

    User.create!(name: "Tayyab Shabab",
                 email: "tayyabshabab@yahoo.com",
                 password: "test123",
                 password_confirmation: "test123")

    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
  end
end