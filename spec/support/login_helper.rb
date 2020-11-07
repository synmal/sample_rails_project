module AccessTokenHelper
  def user_access_token
    user = create(:user)
    Doorkeeper::AccessToken.create!(resource_owner_id: user.id).token
  end

  def moderator_access_token
    user = create(:user, :moderator)
    Doorkeeper::AccessToken.create!(resource_owner_id: user.id).token
  end
end

RSpec.configure do |config|
  config.include AccessTokenHelper
end