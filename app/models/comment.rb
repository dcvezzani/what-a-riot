class Comment < ActiveRecord::Base
  validates :author_id, :body, :recorded_on, presence: true
end
