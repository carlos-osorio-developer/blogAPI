FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    published { Faker::Boolean.boolean }
    user
  end

  factory :published_post, parent: :post do
    published { true }
  end
end
