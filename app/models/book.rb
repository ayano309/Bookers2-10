class Book < ApplicationRecord
  belongs_to :user
 
  has_many :comments ,dependent: :destroy
  has_many :favorites, dependent: :destroy
  #tag
  has_many :tagbooks, dependent: :destroy,foreign_key: 'book_id'
  has_many :tags, through: :tagbooks
  
  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }
  
  scope :latest, -> {order(created_at: :desc)}
  scope :old, ->{order(created_at: :asc)}
  scope :star_count, ->{order(rate: :desc)}
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
  def save_tag(sent_tags)
    # タグが存在していれば、タグの名前を配列として全て取得
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    # 現在取得したタグから送られてきたタグを除いてoldtagとする
    old_tags = current_tags - sent_tags
    # 送信されてきたタグから現在存在するタグを除いたタグをnewとする
    new_tags = sent_tags - current_tags
    
     # 古いタグを消す
      old_tags.each do |old|
        self.tags.delete Tag.find_by(name:old)
      end
    
     # 新しいタグを保存
      new_tags.each do |new|
        book_tag = Tag.find_or_create_by(name:new)
        # 配列に保存
        self.tags << book_tag
      end
  end
  
  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end
end
