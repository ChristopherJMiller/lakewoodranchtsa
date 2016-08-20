class Event < ActiveRecord::Base
  validates :name, presence: true
  validates :name, length: { minimum: 1, maximum: 64 }
  validates :description, presence: true
  validates :description, length: { maximum: 1024 }
  validates :max_members_per_team, presence: true
  validates :max_members_per_team, numericality: { greater_than: 0 }

  has_many :teams
end
