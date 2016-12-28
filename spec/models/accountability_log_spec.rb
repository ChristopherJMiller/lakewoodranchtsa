require 'rails_helper'

RSpec.describe AccountabilityLog, type: :model do
  it 'will be valid with valid information' do
    accountabilitylog = AccountabilityLog.new(dueby: '2016-6-1', closingdate: '2016-6-5')
    expect(accountabilitylog).to be_valid
  end

  it 'will not be valid with a missing due by date' do
    accountabilitylog = AccountabilityLog.new(dueby: nil, closingdate: '2016-6-5')
    expect(accountabilitylog).not_to be_valid
  end

  it 'will not be valid with a missing closed by date' do
    accountabilitylog = AccountabilityLog.new(dueby: '2016-6-1', closingdate: nil)
    expect(accountabilitylog).not_to be_valid
  end
end
