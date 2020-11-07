require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  it 'should be able to create' do
    expect(user.save).to be true
  end

  it 'should not be moderator by default' do
    expect(user.moderator?).to be false
  end

  it 'should respond to `moderator?` method' do
    expect(user.respond_to? 'moderator?')
  end

  it 'should not have moderator column empty' do
    user.moderator = nil
    expect{ user.save! }.to raise_error(ActiveRecord::NotNullViolation)
  end

  it 'should be able to authenticate' do
    user.save
    expect(User.authenticate(user.email, user.password)).to be_instance_of User
  end
end