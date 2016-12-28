# Announcement for site wide posting
class Announcement < ActiveRecord::Base
  belongs_to :user

  validates :title, presence: true
  validates :title, length: {maximum: 64}
  validates :body, presence: true
  validates :body, length: {maximum: 5120}
  validates :user, presence: true
end
