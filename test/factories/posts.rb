FactoryBot.define do
  factory :post do
    title { "MyString" }
    content { "MyText" }
    published { false }
    user { nil }
  end
end
