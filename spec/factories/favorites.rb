FactoryBot.define do
  factory :favorite, class: 'Favorite' do
    post_id { nil }
    user_id { nil }
  end
end
