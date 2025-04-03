class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # アソシエーション
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  # フォロー関係（自分がフォローしてるユーザー）
  has_many :relationships, foreign_key: :follower_id, dependent: :destroy
  has_many :followings, through: :relationships, source: :followed

  # フォローされているユーザー（自分をフォローしてる人）
  has_many :reverse_relationships, class_name: 'Relationship', foreign_key: :followed_id, dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  # バリデーション
  validates :name, presence: true, length: { maximum: 20 }

  # enum（学習フェーズ）
  enum phase: { basic_learning: 0, personal_dev: 1, job_hunting: 2 }
end
