class Post < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  validates :title, presence: true, length: { maximum: 75 }
  validates :content, presence: true, length: { maximum: 750 }
  validates :published, inclusion: { in: [true, false] }

  def self.search(keyword)
    Post.where(['title LIKE ?', "%#{keyword}%"]).where(published: true).includes(:user)
  end
end
