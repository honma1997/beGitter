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
  
  # 検索メソッド
  def self.search(keyword, tag_ids = nil)
    posts = all
    
    # キーワード検索
    if keyword.present?
      posts = posts.where('title LIKE ? OR body LIKE ?', "%#{keyword}%", "%#{keyword}%")
    end
    
    # タグ検索
    if tag_ids.present? && tag_ids.reject(&:blank?).present?
      posts = posts.joins(:post_tags).where(post_tags: { tag_id: tag_ids }).distinct
    end
    
    posts
  end
end