class Bounty < ApplicationRecord
  belongs_to :user
  validates :title, :description, :company_name, presence: true

  enum status: {
    pending: 'pending',
    rejected: 'rejected',
    approved: 'approved'
  }
end
