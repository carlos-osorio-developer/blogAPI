class User < ApplicationRecord

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :auth_token, presence: true, uniqueness: true

  has_many :posts, dependent: :destroy
end
