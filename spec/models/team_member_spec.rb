require 'rails_helper'

RSpec.describe TeamMember, type: :model do
  let (:team) do
    FactoryGirl.create(:team)
  end

  let (:user) do
    FactoryGirl.create(:user)
  end

  it 'should be valid with valid information' do
    team_member = TeamMember.new(user_id: user.id, team_id: team.id, admin: true)
    expect(team_member).to be_valid
  end

  it 'should not be valid with a missing user' do
    team_member = TeamMember.new(user_id: nil, team_id: team.id, admin: true)
    expect(team_member).to_not be_valid
  end

  it 'should be valid with a missing team' do
    team_member = TeamMember.new(user_id: user.id, team_id: nil, admin: true)
    expect(team_member).to_not be_valid
  end

  it 'should not be valid with an invalid admin boolean' do
    team_member = TeamMember.new(user_id: user.id, team_id: team.id, admin: nil)
    expect(team_member).to_not be_valid
  end
end
