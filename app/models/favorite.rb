class Favorite < ApplicationRecord
  belongs_to :post
  belongs_to :user
  validates_uniqueness_of :post_id, scope: :user_id
  validates :user_id, presence: true
  validates :post_id, presence: true
end
