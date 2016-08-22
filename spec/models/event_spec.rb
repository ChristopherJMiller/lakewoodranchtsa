require 'rails_helper'

RSpec.describe Event, type: :model do
  it 'should be valid with valid information' do
    event = Event.new(name: 'Test Event', description: 'Hello World!', max_members_per_team: 3)
    expect(event).to be_valid
  end

  it 'should not be valid with a missing name' do
    event = Event.new(name: nil, description: 'Hello World!', max_members_per_team: 3)
    expect(event).to_not be_valid
  end

  it 'should not be valid with an invalid name' do
    event = Event.new(name: '0' * 65, description: 'Hello World!', max_members_per_team: 3)
    expect(event).to_not be_valid
  end

  it 'should not be valid with a missing description' do
    event = Event.new(name: 'Test Event', description: nil, max_members_per_team: 3)
    expect(event).to_not be_valid
  end

  it 'should not be valid with an invalid description' do
    event = Event.new(name: 'Test Event', description: '0' * 1025, max_members_per_team: 3)
    expect(event).to_not be_valid
  end

  it 'should not be valid with a missing max members per team' do
    event = Event.new(name: 'Test Event', description: 'Hello World!', max_members_per_team: nil)
    expect(event).to_not be_valid
  end

  it 'should not be valid with an invalid max members per team' do
    event = Event.new(name: 'Test Event', description: 'Hello World!', max_members_per_team: -1)
    expect(event).to_not be_valid
  end
end
