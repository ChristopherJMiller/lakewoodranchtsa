require 'rails_helper'

RSpec.describe Submission, type: :model do

  let(:user) do
    FactoryGirl.create(:user)
  end

  let(:accountability_log) do
    FactoryGirl.create(:accountability_log)
  end

  it 'should be valid with valid information' do
    submission = Submission.new(binderstatus: 'Binder', tasks: 'Tasks', goals: 'Goals', user_id: user.id, accountability_log_id: accountability_log.id)
    expect(submission).to be_valid
  end

  it 'should not be valid with a missing binder status' do
    submission = Submission.new(binderstatus: nil, tasks: 'Tasks', goals: 'Goals', user_id: user.id, accountability_log_id: accountability_log.id)
    expect(submission).to_not be_valid
  end

  it 'should not be valid with an invalid binder status' do
    submission = Submission.new(binderstatus: '0' * 2049, tasks: 'Tasks', goals: 'Goals', user_id: user.id, accountability_log_id: accountability_log.id)
    expect(submission).to_not be_valid
  end

  it 'should not be valid with missing tasks' do
    submission = Submission.new(binderstatus: 'Binder', tasks: nil, goals: 'Goals', user_id: user.id, accountability_log_id: accountability_log.id)
    expect(submission).to_not be_valid
  end

  it 'should not be valid with an invalid task text' do
    submission = Submission.new(binderstatus: 'Binder', tasks: '0' * 2049, goals: 'Goals', user_id: user.id, accountability_log_id: accountability_log.id)
    expect(submission).to_not be_valid
  end

  it 'should not be valid with a missing goals text' do
    submission = Submission.new(binderstatus: 'Binder', tasks: 'Tasks', goals: nil, user_id: user.id, accountability_log_id: accountability_log.id)
    expect(submission).to_not be_valid
  end

  it 'should not be valid with an invalid goals text' do
    submission = Submission.new(binderstatus: 'Binder', tasks: 'Tasks', goals: '0' * 2049, user_id: user.id, accountability_log_id: accountability_log.id)
    expect(submission).to_not be_valid
  end

  it 'should not be valid with a missing user' do
    submission = Submission.new(binderstatus: 'Binder', tasks: 'Tasks', goals: 'Goals', user_id: nil, accountability_log_id: accountability_log.id)
    expect(submission).to_not be_valid
  end

  it 'should not be valid with a missing binder status' do
    submission = Submission.new(binderstatus: 'Binder', tasks: 'Tasks', goals: 'Goals', user_id: user.id, accountability_log_id: nil)
    expect(submission).to_not be_valid
  end
end
