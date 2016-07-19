require 'rails_helper'

RSpec.describe User, type: :model do
  it 'should be a valid user' do
    user = User.new(name: 'John Doe', email: 'test@test.com', password: 'password1234', password_confirmation: 'password1234', verified: true, verify_token: '', rank: 0)
    expect(user).to be_valid
  end
  it 'should not be valid with a missing name' do
    user = User.new(name: nil, email: 'test@test.com', password: 'password1234', password_confirmation: 'password1234', verified: true, verify_token: '', rank: 0)
    expect(user).to_not be_valid
  end
  it 'should not be valid with a missing email' do
    user = User.new(name: 'John Doe', email: nil, password: 'password1234', password_confirmation: 'password1234', verified: true, verify_token: '', rank: 0)
    expect(user).to_not be_valid
  end
  it 'should not be valid with an invalid email' do
    user = User.new(name: 'John Doe', email: 'testtest.com', password: 'password1234', password_confirmation: 'password1234', verified: true, verify_token: '', rank: 0)
    expect(user).to_not be_valid
  end
  it 'should not be valid with a mismatched password' do
    user = User.new(name: 'John Doe', email: 'test@test.com', password: 'password1234', password_confirmation: 'password12345', verified: true, verify_token: '', rank: 0)
    expect(user).to_not be_valid
  end
  it 'should not be valid with a duplicate email' do
    User.create(name: 'John Doe', email: 'test@test.com', password: 'password1234', password_confirmation: 'password1234', verified: true, verify_token: '', rank: 0)
    user = User.new(name: 'John Doe', email: 'test@test.com', password: 'password1234', password_confirmation: 'password1234', verified: true, verify_token: '', rank: 0)
    expect(user).to_not be_valid
  end
  it 'should not be valid with an unroutable email' do
    user = User.new(name: 'John Doe', email: 'test@localhost', password: 'password1234', password_confirmation: 'password1234', verified: true, verify_token: '', rank: 0)
    expect(user).to_not be_valid
  end
  it 'should not be valid with a missing password' do
    user = User.new(name: 'John Doe', email: 'test@test.com', password: nil, password_confirmation: nil, verified: true, verify_token: '', rank: 0)
    expect(user).to_not be_valid
  end
  it 'should not be valid with a short password' do
    user = User.new(name: 'John Doe', email: 'test@test.com', password: 'pass', password_confirmation: 'pass', verified: true, verify_token: '', rank: 0)
    expect(user).to_not be_valid
  end
  it 'should not be valid with an undefined verified' do
    user = User.new(name: 'John Doe', email: 'test@test.com', password: 'password1234', password_confirmation: 'password1234', verified: nil, verify_token: '', rank: 0)
    expect(user).to_not be_valid
  end
  it 'should not be valid with an undefined rank' do
    user = User.new(name: 'John Doe', email: 'test@test.com', password: 'password1234', password_confirmation: 'password1234', verified: '', verify_token: '', rank: nil)
    expect(user).to_not be_valid
  end
end
