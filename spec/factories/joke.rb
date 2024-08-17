FactoryBot.define do
  factory :joke do

    #category_id { rand(2..15) }
    category_id { 2 }
    input_text1 { Faker::Lorem.word }
    input_text2 { Faker::Lorem.word }
    association :user

    after(:build) do |joke|
      joke.user ||= FactoryBot.build(:user)
    end
  end
end
