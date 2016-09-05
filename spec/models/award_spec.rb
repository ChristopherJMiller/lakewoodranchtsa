require 'rails_helper'

RSpec.describe Award, type: :model do

  let(:user) do
    FactoryGirl.create(:user, rank: 1)
  end

  it 'should be valid with valid information' do
    award = Award.new(name: 'Test Award', value: 5, verified: false, user_id: user.id)
    expect(award).to be_valid
  end

  it 'should not be valid with a missing name' do
    award = Award.new(name: nil, value: 5, verified: false, user_id: user.id)
    expect(award).to_not be_valid
  end

  it 'should not be valid with a missing value' do
    award = Award.new(name: 'Test Award', value: nil, verified: false, user_id: user.id)
    expect(award).to_not be_valid
  end

  it 'should not be valid with an invalid verified' do
    award = Award.new(name: 'Test Award', value: 5, verified: nil, user_id: user.id)
    expect(award).to_not be_valid
  end

  it 'should not be valid with an invalid value' do
    award = Award.new(name: 'Test Award', value: -1, verified: false, user_id: user.id)
    expect(award).to_not be_valid
  end

  it 'should not be valid with a missing user' do
    award = Award.new(name: 'Test Award', value: 5, verified: false, user_id: nil)
    expect(award).to_not be_valid
  end
end
