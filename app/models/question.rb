class Question < ApplicationRecord
  extend FriendlyId

  mount_uploader :image, ImageUploader
  # the :history option will keep a history for the slugs in a the
  # friendly_id_slugs table which support slugs that were used before for the
  # model
  # the :finders option will make so that Question.find will work if you give it
  # a slug instead of an id (otherwise, you would have to use
  # Question.friendly.find)
  friendly_id :title, use: [:slugged, :history, :finders]
  # Question.find_each(&:save) #Question.all.each {|q| q.save }

  # this sets up one-to-many association between the question and the answer
  # in this case a question has many answers (note that to set a one-to-many
  # association you will have to pluralize `answer` - Rails convention)
  # we will have many handy method to helps us query associated records.
  # for instance we can do:
  # q = Question.last
  # answers = q.answers
  # the line above will fetch all the answers associated with question: q
  # we do this because Rails doesn't know if you want one to one or one to many
  # It's highly recommended that you add the `dependent` option to the
  # association which tells Rails what to do when you delete a question that
  # has answers associated with it, the most popular options are:
  # destroy: which will delete all associated answers before deleting the
  #          question
  # nullify: which will update all the `question_id` fields on the associated
  #          answers to be come `NULL` before deleting the question
  # has_many :answers, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :answers, lambda { order(created_at: :desc) }, dependent: :destroy
  belongs_to :user, optional: true

  has_many :likes, dependent: :destroy # 👈 q.likes
  # 👇 will create an instance method named liking_users that will get all users that
  # liked the question
  # through - this argument defines which model is used for the join (i.e. the table that
  # has a reference to the user and the question)
  # source - this argument defines what is the target reference from the like model
  has_many :liking_users, through: :likes, source: :user

  has_many :votes, dependent: :destroy
  has_many :voters, through: :votes, source: :user

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  # q.liking_users

  # q.liking_users << User.last : insert last user into the the liking users list
  # of the question

  # validates :title,  presence: true
  # validates is rails method
  # validates(:title, { presence: true })
  # You can add your own message
  # validates :title, { presence: { message: 'must be given!' } }
  validates(:title, { presence: { message: 'must be given!' },
                      uniqueness: true })
  validates :body, presence: true, length: { minimum: 5 }
  validates :view_count, presence: true,
                         numericality: { greter_than_or_equal_to: 0 }

  # when use `valitates` with an `s` then Rails expect one of the Rails built-in
  # validation options such as: :presense, :uniqueness, :numericality..etc

  # if you want to write a custom validation method then you will need to use
  # `validate` (no s)
  # custom validation method

  validate :no_monkey

  # this callback runs after a question is successfully created
  after_save(:alert_us)

  # the following is a callback that will run the method set_view_count
  # before any validation is run on the model
  after_initialize(:set_view_count)

  def liked_by?(user)
    # exists? returns true if the query in the argument returns something
    # it reutrns true if there is a like with the user reference `user`
    likes.exists?(user: user)
  end

  def like_for(user)
    likes.find_by(user: user)
    # likes.find_by_user_id user.id
  end

  # by using <% if vote.nil? %>
  # def voted_by?(user)
  #   votes.exists?(user: user)
  #   # self.votes.existe?(user: user)
  # end

  def vote_for(user)
    votes.find_by(user: user)
    # find_by returns only one data
  end

  def votes_total
    # votes.where(is_up: true).count - votes.where(is_up: false).count
    votes.up.count - votes.down.count
  end

  # define a class method by adding self. in front of a method name
  # This method will be calleable on the class itself (i.e. Question.search("thing"))
  # needed to keep this class method here other than making it private cause
  # controller will called this method when it's requested.
  def self.search(query)
    where("title ILIKE ? or body ILIKE ?", "%#{query}%", "%#{query}%")
  end

# 🖕 class method and when self used inside method like 👇 self refers
# instance of the class (the object you create!)
# methods under private area can be only called inside class

  # def to_param
  #   # id is default in show page /questions/10 #{question.to_param} rails does this
  #   "#{id}-#{title}".parameterize
  # end

  private

  def set_view_count
    self.view_count = 0
  end

  def alert_us
    puts "🎉"
  end
  # this will called before validation methods
  def no_monkey
    if title.present? && title.downcase.include?('monkey')
      errors.add(:title, 'No monkeys please!')
    end
  end
end
