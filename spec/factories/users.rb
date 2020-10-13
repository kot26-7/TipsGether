FactoryBot.define do
  factory :user, class: 'User' do
    username { 'test' }
    email { 'TESTtest@example.com' }
    password { 'password' }

    factory :other_user, class: 'User' do
      username { 'foobar' }
      email { 'hogehoge@example.com' }
    end
  end
end
