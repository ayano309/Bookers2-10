class Tag < ApplicationRecord
  has_many :tagbooks, dependent: :destroy, foreign_key: 'tag_id'
  has_many :books, through: :tagbooks
  
  validates :name, uniqueness: true, presence: true
  
  
  def self.search_books_for(search, word)
    
    if search == "perfect_match"
      tags = Tag.where(name: word)
    elsif search == "forward_match"
      tags = Tag.where('name LIKE ?', word + '%')
    elsif search == "backward_match"
      tags = Tag.where('name LIKE ?', '%' + word)
    elsif search == "partial_match"
      tags = Tag.where('name LIKE ?', '%' + word + '%')
    end
    # injectはたたみ込み演算
    return tags.inject(init = []) {|result, tag| result + tag.books}
  end
end
