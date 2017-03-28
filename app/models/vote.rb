class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :question_id, uniqueness: { scope: :user_id }

  # scope :up, lambda { where(is_up: true) }
  def self.up
    where(is_up: true)
  end

  def self.down
    where(is_up: false)
  end
end
