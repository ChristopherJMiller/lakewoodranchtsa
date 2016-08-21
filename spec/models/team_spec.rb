require 'rails_helper'

RSpec.describe Team, type: :model do
  let (:event) do
    FactoryGirl.create(:event)
  end

  it 'should be valid with valid information' do
    team = Team.new(name: 'Test Team', event_id: event.id, closed: false)
    expect(team).to be_valid
  end

  it 'should not be valid with a missing team name' do
    team = Team.new(name: nil, event_id: event.id, closed: false)
    expect(team).to_not be_valid
  end

  it 'should not be valid with too short of a team name' do
    team = Team.new(name: '', event_id: event.id, closed: false)
    expect(team).to_not be_valid
  end

  it 'should not be valid with too long of a team name' do
    team = Team.new(name: '0' * 65, event_id: event.id, closed: false)
    expect(team).to_not be_valid
  end

  it 'should not be valid with a missing event' do
    team = Team.new(name: 'Test Team', event_id: nil, closed: false)
    expect(team).to_not be_valid
  end

  it 'should not be valid with an invalid closed boolean' do
    team = Team.new(name: 'Test Team', event_id: event.id, closed: nil)
    expect(team).to_not be_valid
  end
end
