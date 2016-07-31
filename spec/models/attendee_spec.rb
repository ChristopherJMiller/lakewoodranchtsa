require 'rails_helper'

RSpec.describe Attendee, type: :model do

  let(:user) do
    FactoryGirl.create(:user)
  end

  let(:sign_up_sheet) do
    FactoryGirl.create(:sign_up_sheet)
  end

  it 'should be valid with valid information' do
    attendee = Attendee.new(user_id: user.id, sign_up_sheet_id: sign_up_sheet.id)
    expect(attendee).to be_valid
  end

  it 'should not be valid with a missing user' do
    attendee = Attendee.new(user_id: nil, sign_up_sheet_id: sign_up_sheet.id)
    expect(attendee).to_not be_valid
  end

  it 'should not be valid with a missing sign up sheet' do
    attendee = Attendee.new(user_id: user.id, sign_up_sheet_id: nil)
    expect(attendee).to_not be_valid
  end

  it 'should not be valid with a conflicting user' do
    Attendee.create(user_id: user.id, sign_up_sheet_id: sign_up_sheet.id)
    attendee = Attendee.new(user_id: user.id, sign_up_sheet_id: sign_up_sheet.id)
    expect(attendee).to_not be_valid
  end
end
