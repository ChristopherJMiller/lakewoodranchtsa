# = User
# Represents a user on the website
#
# == Data
# [name]  String that contains the user's real name.
# [email] String that contains the user's email, used to send the verification email.
# [password_digest] Pair of strings that contains the user's password.
# [verified] Boolean that contains if the user has been verified by email.
# [verify_token] String that contains the verification token that is send by email to verify the user
# [rank] Integer that defines the user's site rank
# === Ranks
# [0] Unpaid Member
# [1] Member
# [2] Sergeant-at-Arms
# [3] Reporter
# [4] Treasurer
# [5] Secretary
# [6] Vice President
# [7] President
# [8] Advisor
# == Attributes
# * Adds a token before creation.
# * Must have a secure password (At least 8 characters long and be present)
# * Name must be present
# * Email must be present, must be formatted properly, and must be unique
# * Verified must be either true or false
class User < ActiveRecord::Base

  before_create :add_token

  has_secure_password
  validates :name, presence: true
  validates :email, presence: true
  validates :email, email_format: { check_mx: true }
  validates :email, uniqueness: true
  validates :password, length: { minimum: 8 }, on: :create
  validates :verified, inclusion: [true, false]

  validates :rank, presence: true

  # Renders a user as json with the password_digest excluded.
  def as_json(options={})
    options[:except] ||= [:password_digest]
    super(options)
  end

  # Returns whether the user has paid their fees and thus if they are offically considered a member.
  def is_member
    rank > 0
  end

  # Returns if the user is an admin or not.
  def is_admin
    rank > 1
  end

  # Returns if the user is an advisor or not.
  def is_advisor
    rank > 7
  end

  def rank_title
    titles = ["User", "Member", "Sergeant-at-Arms", "Reporter", "Treasurer", "Secretary", "Vice President", "President", "Advisor"]
    titles[rank]
  end

  private
    def add_token
      if self.verify_token.blank?
          self.verify_token = SecureRandom.uuid
      end
    end
end
