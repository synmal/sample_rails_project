require 'swagger_helper'

RSpec.describe 'Bounties API', type: :request do
  path '/bounties' do
    post 'Create a Bounty' do
      tags 'Bounties'
      description 'Creates a Bounty'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :access_token, in: :query, type: :string, description: 'Access Token generated from login. Both users and moderators can create bounty', required: true
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
        let(:access_token) { user_access_token }
        let(:bounty) { {bounty: { title: 'Title', description: 'Description', company_name: 'Company Name' }} }
        run_test!
      end

      response '401', 'Unauthorized request' do
        let(:access_token) { 'asd' }
        let(:bounty) { {bounty: { title: 'Title', description: 'Description', company_name: 'Company Name' }} }
        run_test!
      end

      response '400', 'Bad request' do
        let(:access_token) { user_access_token }
        let(:bounty) { {bounty: { description: 'Description', company_name: 'Company Name' }} }
        run_test!
      end
    end

    get 'Get All Bounties' do
      tags 'Bounties'
      description 'Get all approved bounties'
      parameter name: :company_name, in: :query, required: false, description: 'Append `company_name` to path to filter bounties by company name'
      produces 'application/json'

      response '200', 'Returns an array of approved bounties' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              title: { type: :string },
              description: { type: :string },
              company_name: { type: :string },
              user_id: { type: :integer },
              status: { type: :string },
              created_at: { type: :string },
              updated_at: { type: :string }
            }
          }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end

        before {
          create(:bounty)
          create(:rejected_bounty)
          create(:approved_bounty)
        }

        before do |example|
          submit_request(example.metadata)
        end

        it 'returns approved bounties only' do |_example|
          JSON.parse(response.body).each do |bounty|
            expect(bounty["status"]).to eq('approved')
          end
        end
      end
    end
  end

  path '/bounties/{id}/reject' do
    post 'Reject a bounty' do
      tags 'Bounties'
      description 'Reject a bounty'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, description: 'ID of bounty'
      parameter name: :access_token, in: :query, type: :string, description: 'Moderator Access Token', required: true

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
          }

        let!(:id) { create(:bounty).id }
        let!(:access_token) { moderator_access_token }

        run_test!
      end

      response '401', 'Unauthorized request' do
        let!(:id) { create(:bounty).id }
        let!(:access_token) { user_access_token }
      end
    end
  end

  path '/bounties/{id}/approve' do
    post 'Approve a bounty' do
      tags 'Bounties'
      description 'Approve a bounty'
      produces 'application/json'
      parameter name: :id, in: :path, type: :id, description: 'ID of bounty'
      parameter name: :access_token, in: :query, type: :string, description: 'Moderator Access Token', required: true

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
          }

        let!(:id) { create(:bounty).id }
        let!(:access_token) { moderator_access_token }
        run_test!
      end

      response '401', 'Unauthorized request' do
        let!(:id) { create(:bounty).id }
        let!(:access_token) { user_access_token }
      end
    end
  end

  path '/bounties/pending_action' do
    get 'Get all pending bounties' do
      tags 'Bounties'
      description 'Get all pending bounties'
      produces 'application/json'
      parameter name: :access_token, in: :query, type: :string, description: 'Moderator Access Token', required: true

      response '200', 'Returns an array of pending bounties' do
        schema type: :array,
          items: {
            type: :object,
            properties: {
              id: { type: :integer },
              title: { type: :string },
              description: { type: :string },
              company_name: { type: :string },
              user_id: { type: :integer },
              status: { type: :string },
              created_at: { type: :string },
              updated_at: { type: :string }
            }
          }

        after do |example|
          example.metadata[:response][:examples] = { 'application/json' => JSON.parse(response.body, symbolize_names: true) }
        end

        before {
          create(:bounty)
          create(:rejected_bounty)
          create(:approved_bounty)
        }

        let!(:access_token){ moderator_access_token }

        before do |example|
          submit_request(example.metadata)
        end

        it 'returns pending bounties only' do |_example|
          JSON.parse(response.body).each do |bounty|
            expect(bounty["status"]).to eq('pending')
          end
        end
      end

      response '401', 'Unauthorized request' do
        let!(:id) { create(:bounty).id }
        let!(:access_token) { user_access_token }
      end
    end
  end
end
