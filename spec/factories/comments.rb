FactoryBot.define do
  factory :comment, class: 'Comment' do
    content { "this is a comment" }
    user_id { 1 }
    post_id { 1 }

    factory :another_comment, class: 'Comment' do
      user_id { 2 }
    end
  end
end
