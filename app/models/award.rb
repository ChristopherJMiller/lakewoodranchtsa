class Award < ActiveRecord::Base
  validates :name, presence: true
  validates :name, length: { maximum: 128 }

  validates :value, presence: true
  validates :value, numericality: { greater_than: 0 }

  validates :verified, inclusion: [true, false]
end
