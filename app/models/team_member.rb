# A member of a specific team for a certain event
class TeamMember < ActiveRecord::Base
  belongs_to :user
  belongs_to :team

  validates :user, presence: true
  validates :team, presence: true
  validates :user, uniqueness: {scope: :team}

  validates :admin, inclusion: [true, false]

  def admin?
    admin
  end
end
