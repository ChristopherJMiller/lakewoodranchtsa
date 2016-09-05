class Award < ActiveRecord::Base
  belongs_to :user

  validates :name, presence: true
  validates :name, length: { maximum: 128 }

  validates :value, presence: true
  validates :value, numericality: { greater_than: -1 }

  validates :verified, inclusion: [true, false]

  validates :user, presence: true
end
