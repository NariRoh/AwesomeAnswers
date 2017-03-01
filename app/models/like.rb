class Like < ApplicationRecord
  belongs_to :user
  belongs_to :question

  # the following validations garantees that a user can only like a question once
  # this will ensure that the question_id / user_id combo is unique
  validates :question_id, uniqueness: { scope: :user_id }
end
