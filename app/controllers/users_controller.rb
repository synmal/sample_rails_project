class UsersController < ApplicationController
  before_action :doorkeeper_authorize!

  def index
    @users = User.all
    respond_with @users
  end
end
