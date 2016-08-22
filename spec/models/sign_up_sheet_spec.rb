require 'rails_helper'

RSpec.describe SignUpSheet, type: :model do

  it 'should be valid with valid information' do
    sign_up_sheet = SignUpSheet.new(name: 'Sign Up Sheet', date: '2016-07-01')
    expect(sign_up_sheet).to be_valid
  end

  it 'should not be valid with a missing name' do
    sign_up_sheet = SignUpSheet.new(name: nil, date: '2016-07-01')
    expect(sign_up_sheet).to_not be_valid
  end

  it 'should not be valid with too large of a name' do
    sign_up_sheet = SignUpSheet.new(name: '0' * 129, date: '2016-07-01')
    expect(sign_up_sheet).to_not be_valid
  end

  it 'should not be valid with a missing date' do
    sign_up_sheet = SignUpSheet.new(name: 'Sign Up Sheet', date: nil)
    expect(sign_up_sheet).to_not be_valid
  end
end
