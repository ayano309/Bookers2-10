class Tag < ApplicationRecord
  has_many :tagbooks, dependent: :destroy, foreign_key: 'tag_id'
  has_many :books, through: :tagbooks
  
  validates :name, uniqueness: true, presence: true
end
