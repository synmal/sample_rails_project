class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :bounties

  def self.authenticate(email, password)
     user = self.find_for_authentication(email: email)
     user.try(:valid_password?, password) ? user : nil
  end
end
