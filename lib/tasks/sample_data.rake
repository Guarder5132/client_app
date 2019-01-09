namespace :db do
    desc "Fill database with sample data"
    task populate: :environment do
        User.create!(name: "Guard_tuzi",
            email: "Guard@example.com",
            password: "Guarder",
            password_confirmation: "Guarder",
            admin:true)
        99.times do |n|
            name = Faker::Name.name
            email = "example-#{n+1}@example.com"
            password = "password"
            User.create!(name: name,
                         email: email,
                         password: password,
                         password_confirmation: password)
        end
    end
end