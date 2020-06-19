class Contribution < ApplicationRecord
  belongs_to :user
  validates :title, presence: true
  
  has_many :comments
  
end
