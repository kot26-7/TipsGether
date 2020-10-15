class Post < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :users_made_favorite, through: :favorites, source: :user
  validates :title, presence: true, length: { maximum: 75 }
  validates :content, presence: true, length: { maximum: 750 }
  validates :published, inclusion: { in: [true, false] }
end
