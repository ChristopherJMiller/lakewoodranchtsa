# Attendees for Sign Up Sheets
class Attendee < ActiveRecord::Base
  belongs_to :user
  belongs_to :sign_up_sheet

  validates :user, presence: true
  validates :sign_up_sheet, presence: true
  validates :user, uniqueness: {scope: :sign_up_sheet}
end
