require 'swagger_helper'

RSpec.describe 'Bounties API', type: :request do

  path '/bounties' do
    post 'Create a Bounty' do
      tags 'Bounties'
      description 'Creates a Bounty'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :access_token, in: :path, description: 'Access Token generated from login. Both users and moderators can create bounty'
      parameter name: :bounty, in: :body, schema: {
        type: :object,
        properties: {
          bounty: {
            type: :object,
            properties: {
              title: { type: :string },
              description: { type: :string },
              company_name: { type: :string }
            },
            required: [ 'title', 'description', 'company_name' ]
          }
        }
      }

      response '201', 'Bounty successfully created' do
        let(:bounty) { {bounty: { title: 'Title', description: 'Description', company_name: 'Company Name' }} }
        run_test!
      end
    end

    get 'Get All Bounties' do
      tags 'Bounties'
      description 'Get all approved bounties'
      parameter name: :company_name, in: :query, required: false, description: 'Append `company_name` to path to filter bounties by company name'
      produces 'application/json'

      response '200', 'Returns an array of approved bounties' do
        before { FactoryBot.create_list(:approved_bounty, 2) }
        run_test!
      end
    end
  end

  path '/bounties/{id}/reject' do
    post 'Reject a bounty' do
      tags 'Bounties'
      description 'Reject a bounty'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'ID of bounty'
      parameter name: :access_token, in: :path, type: :string, description: 'Moderator Access Token'

      response '200', 'Successfully Rejected' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            title: { type: :string },
            description: { type: :string },
            status: { type: :string },
            user_id: { type: :integer },
            company_name: { type: :string },
            created_at: { type: :string },
            updated_at: { type: :string }
          },
          required: %w( id title description status user_id company_name created_at updated_at )

        let(:id) { Bounty.create(title: 'Title', description: 'description', company_name: 'Company Name', status: 'rejected').id }
        run_test!
      end
    end
  end

  path '/bounties/{id}/approve' do
    post 'Approve a bounty' do
      tags 'Bounties'
      description 'Approve a bounty'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'ID of bounty'
      parameter name: :access_token, in: :path, type: :string, description: 'Moderator Access Token'

      response '200', 'Successfully Approved' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            title: { type: :string },
            description: { type: :string },
            status: { type: :string },
            user_id: { type: :integer },
            company_name: { type: :string },
            created_at: { type: :string },
            updated_at: { type: :string }
          },
          required: %w( id title description status user_id company_name created_at updated_at )

        let(:id) { Bounty.create(title: 'Title', description: 'description', company_name: 'Company Name', status: 'approved').id }
        run_test!
      end
    end
  end

  path '/bounties/pending_action' do
    get 'Get all pending bounties' do
      tags 'Bounties'
      description 'Get all pending bounties'
      produces 'application/json'
      parameter name: :access_token, in: :path, type: :string, description: 'Moderator Access Token'

      response '200', 'Returns an array of pending bounties object' do
        run_test!
      end
    end
  end
end
