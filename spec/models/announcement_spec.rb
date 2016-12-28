require 'rails_helper'

RSpec.describe Announcement, type: :model do
  let(:user) do
    FactoryGirl.create(:user)
  end

  it 'will be valid with valid information' do
    announcement = Announcement.new(title: 'Test Announcement', body: 'Hello World!', user_id: user.id)
    expect(announcement).to be_valid
  end

  it 'will not be valid with a missing title' do
    announcement = Announcement.new(title: nil, body: 'Hello World!', user_id: user.id)
    expect(announcement).not_to be_valid
  end

  it 'will not be valid with an invalid title' do
    announcement = Announcement.new(title: '0' * 65, body: 'Hello World!', user_id: user.id)
    expect(announcement).not_to be_valid
  end

  it 'will not be valid with a missing body' do
    announcement = Announcement.new(title: 'Test Announcement', body: nil, user_id: user.id)
    expect(announcement).not_to be_valid
  end

  it 'will not be valid with an invalid body length' do
    announcement = Announcement.new(title: 'Test Announcement', body: '0' * 5121, user_id: user.id)
    expect(announcement).not_to be_valid
  end

  it 'will not be valid with a missing author' do
    announcement = Announcement.new(title: 'Test Announcement', body: 'Hello World!', user_id: nil)
    expect(announcement).not_to be_valid
  end
end
