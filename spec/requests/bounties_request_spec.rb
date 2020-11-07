require 'rails_helper'

RSpec.describe "Bounties", type: :request do
  before :each do
    @headers = {'Accept': 'application/json', 'Content-Type': 'application/json'}
    @bounty_params = { bounty: attributes_for(:bounty) }
  end

  it 'should able to create' do
    post "/bounties?access_token=#{user_access_token}", params: @bounty_params.to_json, headers: @headers

    expect(response).to have_http_status(:created)
  end

  it 'should not create if not logged in' do
    post '/bounties', params: @bounty_params.to_json, headers: @headers

    expect(response).to have_http_status(:unauthorized)
  end

  it 'should able to reject' do
    bounty = create(:bounty)
    post "/bounties/#{bounty.id}/reject?access_token=#{moderator_access_token}", headers: @headers

    expect(response).to have_http_status(:ok)
    expect(bounty.reload.rejected?).to be true
  end

  it 'should able to approve' do
    bounty = create(:bounty)
    post "/bounties/#{bounty.id}/approve?access_token=#{moderator_access_token}", headers: @headers

    expect(response).to have_http_status(:ok)
    expect(bounty.reload.approved?).to be true
  end

  it 'should not able to reject if not moderator' do
    bounty = create(:bounty)
    post "/bounties/#{bounty.id}/reject?access_token=#{user_access_token}", headers: @headers

    expect(response).to have_http_status(:unauthorized)
  end

  it 'should not able to approve if not moderator' do
    bounty = create(:bounty)
    post "/bounties/#{bounty.id}/approve?access_token=#{user_access_token}", headers: @headers

    expect(response).to have_http_status(:unauthorized)
  end

  it 'should get all approved bounties even if not logged in' do
    create(:bounty)
    create(:rejected_bounty)
    create(:approved_bounty)

    get '/bounties', headers: @headers

    expect(response).to have_http_status(:ok)

    JSON.parse(response.body).each do |bounty|
      expect(bounty["status"]).to eq('approved')
    end
  end

  it 'should able to filter by company name' do
    company_name = Faker::Company.name

    3.times do
      create(:approved_bounty, company_name: company_name)
    end

    5.times do
      create(:approved_bounty)
    end

    get "/bounties?company_name=#{company_name}", headers: @headers

    expect(response).to have_http_status(:ok)

    JSON.parse(response.body).each do |bounty|
      expect(bounty["company_name"]).to eq(company_name)
    end
  end

  it 'show pending bounties to moderator' do
    create(:bounty)
    create(:rejected_bounty)
    create(:approved_bounty)

    get "/bounties/pending_action?access_token=#{moderator_access_token}", headers: @headers

    expect(response).to have_http_status(:ok)

    JSON.parse(response.body).each do |bounty|
      expect(bounty["status"]).to eq('pending')
    end
  end
end
