require 'rails_helper'

RSpec.describe Bounty, type: :model do
  let(:bounty) { build(:bounty) }

  it { should belong_to(:user) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:company_name) }

  it do
    should define_enum_for(:status).
      with_values(pending: 'pending', rejected: 'rejected', approved: 'approved').
      backed_by_column_of_type(:string)
  end

  it 'should be pending by default' do
    bounty.save
    expect(bounty.status).to eq('pending')
  end
end
