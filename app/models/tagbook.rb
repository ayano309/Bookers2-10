class Tagbook < ApplicationRecord
  belongs_to :book
  belongs_to :tag
end
