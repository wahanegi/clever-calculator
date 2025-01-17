FactoryBot.define do
  factory :customer do
    company_name { "MyString" }
    first_name { "MyString" }
    last_name { "MyString" }
    email { "MyString" }
    position { "MyString" }
    address { "MyString" }
    notes { "MyText" }
  end
end
