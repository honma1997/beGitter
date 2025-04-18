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
  def self.search(keyword, tag_ids = nil, user_id = nil, start_date = nil, end_date = nil)
    posts = all
    
    # キーワード検索
    if keyword.present?
      posts = posts.where('title LIKE ? OR body LIKE ?', "%#{keyword}%", "%#{keyword}%")
    end
    
    # タグ検索
    if tag_ids.present?
      # 文字列またはArrayに対応
      tag_ids = Array(tag_ids).flatten.compact.reject(&:blank?)
      
      if tag_ids.any?
        posts = posts.joins(:post_tags).where(post_tags: { tag_id: tag_ids }).distinct
      end
    end
    
    # ユーザーでの絞り込み
    if user_id.present?
      posts = posts.where(user_id: user_id)
    end
    
    # 期間での絞り込み
    if start_date.present?
      posts = posts.where('created_at >= ?', start_date.beginning_of_day)
    end
    
    if end_date.present?
      posts = posts.where('created_at <= ?', end_date.end_of_day)
    end
    
    posts
  end
end