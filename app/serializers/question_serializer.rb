class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_on, :user_name

  has_many :answers

  def created_on
    # in this case `object` refers to the question object we're serializing
    # (coverting to JSON)
    object.created_at.strftime('%Y-%B-%d')
  end

  def user_name
    object.user&.full_name
    # object.user&.full_name&.to_s
    # object.user && object.user.full_name && object.user.full_name.to_s
  end
end
