class Question < ApplicationRecord
  # validates :title,  presence: true
  # validates is rails method
  # validates(:title, { presence: true })
  # You can add your own message
  # validates :title, { presence: { message: 'must be given!' } }
  validates(:title, { presence: { message: 'must be given!' },
                      uniqueness: true })
  validates :body, presence: true, length: { minimum: 3 }
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

  # define a class method by adding self. in front of a method name
  # This method will be calleable on the class itself (i.e. Question.search("thing"))
  def self.search(query)
    where("title ILIKE ? or body ILIKE ?", "%#{query}%", "%#{query}%")
  end

# 🖕 class method and when self used inside method like 👇 self refers
# instance of the class (the object you create!)
# methods under private area can be only called inside class 

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
