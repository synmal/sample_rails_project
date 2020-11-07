class ApplicationController < ActionController::API
  respond_to :json

  private
  def access_token_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
