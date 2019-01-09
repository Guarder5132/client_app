FactoryGirl.define do
    factory :user do
        sequence(:name)  {|n| "Guard_tuzi#{n}"}
        sequence(:email) {|n| "Guard_#{n}@example.com"}
        password    "Guarder"
        password_confirmation   "Guarder"

        factory :admin do
            admin true
        end
    end
end