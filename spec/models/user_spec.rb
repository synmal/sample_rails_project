require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  it 'should be able to create' do
    expect(user.save).to be true
  end
end
