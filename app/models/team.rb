class Team < ActiveRecord::Base
  belongs_to :event

  validates :name, presence: true
  validates :name, length: { minimum: 1, maximum: 64 }
  validates :event, presence: true

  has_many :team_members
  has_many :users, through: :team_members

  def full
    team_members.count >= event.max_members_per_team
  end
end
