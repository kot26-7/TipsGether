class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_posts, through: :favorites, source: :post
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  before_save { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  VALID_USERNAME_REGEX = /\A[a-zA-Z0-9_]+\z/.freeze
  validates :email, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :username, presence: true, length: { maximum: 50 },
                       format: { with: VALID_USERNAME_REGEX }
  validates :introduce, length: { maximum: 500 }

  def self.guest
    find_or_create_by!(email: 'sampleuser@example.com') do |user|
      user.username = 'guestuser'
      user.password = SecureRandom.urlsafe_base64
    end
  end

  def already_fav?(post)
    self.favorites.exists?(post_id: post.id)
  end
end
