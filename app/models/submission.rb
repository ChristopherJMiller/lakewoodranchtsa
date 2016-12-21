# Submission of an Accountability Log
class Submission < ActiveRecord::Base
  belongs_to :accountability_log
  belongs_to :user

  validates :binderstatus, presence: true
  validates :binderstatus, length: {maximum: 2048}
  validates :tasks, presence: true
  validates :tasks, length: {maximum: 2048}
  validates :goals, presence: true
  validates :goals, length: {maximum: 2048}

  validates :user, presence: true
  validates :accountability_log, presence: true
end
