class SignUpSheet < ActiveRecord::Base
  validates :name, presence: true
  validates :name, length: { maximum: 128 }

  validates :date, presence: true

  has_many :attendees
  has_many :users, through: :attendees
end
