class User < ApplicationRecord
  # has_secure_password does a few things for us:
# - it automatically adds `password` and `password_confirmation` attribute
#   like you do attr_accessor :abc in some class. These will be in memory but
#   won't be saved(will be gone! as other info saved) as you don't have fields
#   for them also, it won't create new fields in the user database
# - it automatically adds a presence validator on the password
# - it automatically adds a confirmation validator if you add a
#   password confirmation field
# - when password is provided `has_secure_password` will generate a salt and
#   will generate a digest of the password + salt and it will store it in the
#   `password_digest` field
# - it gives us a handy method called `authentciate` that will help us check
#   if the password is correct
# http://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html#method-i-has_secure_password
  has_secure_password

  has_many :questions, dependent: :nullify

  has_many :likes, dependent: :destroy # 👈 this line allows to do u.likes
  has_many :liked_questions, through: :likes, source: :question
  # 👆 this is a method(name it anything you want) to grab all liked questions by
  # the users // create query  # u.likes.map {|l| l.question }
  # source is what you're trying to get

  has_many :votes, dependent: :destroy
  has_many :voted_questions, through: :votes, source: :question

  serialize :oauth_raw_data

  # before_save // happens for create and update
  before_validation :downcase_email

  before_create :generate_api_key

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true,
                    uniqueness: true,
                    format: VALID_EMAIL_REGEX,
                    unless: :from_oauth?

  def full_name
    "#{first_name} #{last_name}".strip.titleize
  end

  def from_oauth?
    uid.present? && provider.present?
  end

  def self.find_from_oauth(omniauth_data)
    User.where(
      uid: oauth_data['uid'],
      provider: oauth_data['provider']
    ).first
  end

  def self.create_from_omniauth(omniauth_data)
    full_name = omniauth_data['info']['name'].split
    User.create(
      uid: omniauth_data['uid'],
      provider: omniauth_data['provider'],
      first_name: full_name[0],
      last_name: full_name[1],
      oauth_token: omniauth_data['credentials']['token'],
      oauth_secret: omniauth_data['credentials']['secret'],
      oauth_raw_data: omniauth_data,
      password: SecureRandom.hex(16)
    )
  end

  private

  def generate_api_key
    # api_key = // create local variable -  this would work with reading but not writing
    #  so self.api_key
    loop do
      self.api_key = SecureRandom.hex
      break unless User.exists?(api_key: api_key) # to have unique api_key
    end
    # 2.3.1 :001 > User.last.send(:generate_api_key)
    # 2.3.1 :002 > User.all.each {|u| u.send(:generate_api_key); u.save}
  end

  def downcase_email
    self.email&.downcase!
  end

end
