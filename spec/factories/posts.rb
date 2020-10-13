FactoryBot.define do
  factory :unpublished_post, class: 'Post' do
    sequence(:title) { |n| "sample title#{n}" }
    sequence(:content) { |n| "this is sample content#{n}" }
    user_id { 1 }

    factory :published_post, class: 'Post' do
      published { true }
    end
  end
end
