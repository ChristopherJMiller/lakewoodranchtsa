require 'rails_helper'

RSpec.describe AccountabilityLog, type: :model do
  it 'should be valid with valid information' do
    accountabilitylog = AccountabilityLog.new(dueby: '2016-6-1', closingdate: '2016-6-5')
    expect(accountabilitylog).to be_valid
  end

  it 'should not be valid with a missing due by date' do
    accountabilitylog = AccountabilityLog.new(dueby: nil, closingdate: '2016-6-5')
    expect(accountabilitylog).to_not be_valid
  end

  it 'should not be valid with a missing closed by date' do
    accountabilitylog = AccountabilityLog.new(dueby: '2016-6-1', closingdate: nil)
    expect(accountabilitylog).to_not be_valid
  end
end