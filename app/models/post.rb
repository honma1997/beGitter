class Post < ApplicationRecord
  belongs_to :user

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  # ActiveStorage
  has_one_attached :image

  # バリデーション
  validates :title, presence: true
  validates :body, presence: true

def self.search(keyword, tag_ids = nil)
  posts = all
  
  # キーワード検索
  if keyword.present?
    posts = posts.where('title LIKE ? OR body LIKE ?', "%#{keyword}%", "%#{keyword}%")
  end
  
  # タグ検索 - 修正版
  if tag_ids.present?
    # 文字列またはArrayに対応
    tag_ids = Array(tag_ids).flatten.compact.reject(&:blank?)
    
    if tag_ids.any?
      posts = posts.joins(:post_tags).where(post_tags: { tag_id: tag_ids }).distinct
    end
  end
  
  posts
end
end