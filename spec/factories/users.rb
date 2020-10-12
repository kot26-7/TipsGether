FactoryBot.define do
  factory :user do
    id { 1 }
    username { 'test' }
    email { 'TESTtest@example.com' }
    password { 'password' }
    introduce { 'Hi, im sample.' }
  end
end
