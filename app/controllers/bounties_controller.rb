class BountiesController < ApplicationController
  before_action :doorkeeper_authorize!, except: [:index]
  before_action :only_moderators, only: [:approve, :reject, :pending_action]
  before_action :set_bounty, only: [:reject, :approve]

  def index
    bounties = Bounty.approved

    if params[:company_name]
      bounties = bounties.where(company_name: params[:company_name])
    end

    respond_with bounties
  end

  def create
    bounty = access_token_owner.bounties.new(bounty_params)
    if bounty.save
      respond_with bounty, status: :created
    else
      render json: bounty.errors.messages, status: :bad_request
    end
  end

  def reject
    @bounty.rejected!
    respond_with @bounty, status: :ok
  end

  def approve
    @bounty.approved!
    respond_with @bounty, status: :ok
  end

  def pending_action
    bounties = Bounty.pending
    respond_with bounties
  end

  private
  def bounty_params
    params.require(:bounty).permit(:title, :description, :company_name)
  end

  def set_bounty
    @bounty = Bounty.find(params[:id])
  end

  def only_moderators
    respond_with nil, status: :unauthorized unless access_token_owner&.moderator?
  end
end
