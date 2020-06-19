class Comment < ApplicationRecord
 belongs_to :user
  
 belongs_to :contribution

 belongs_to :comments, optional: true

 has_many :comments
 
end