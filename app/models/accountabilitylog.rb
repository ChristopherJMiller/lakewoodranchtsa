class Accountabilitylog < ActiveRecord::Base

  validates :dueby, presence: true
  validates :closingdate, presence: true

  has_many :submissions
  has_many :users, through: :submissions
end
