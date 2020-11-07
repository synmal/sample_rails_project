require 'swagger_helper'

RSpec.describe '/users', type: :request do
  path '/oauth/access_token' do
    post 'Obtain Access Token' do
      tags 'Access Token'
      description 'Obtain Access Token'
      consumes 'application/x-www-form-urlencoded'
      produces 'application/json'
      parameter name: :details, in: :body, schema: {
        type: :object,
        properties: {
          grant_type: {type: :string},
          email: {type: :string},
          password: {type: :string},
        },
        required: %w(grant_type email password)
      }

      response '200', 'Returns access token object' do
        let(:user){ build(:user) }

        run_test!
      end
    end
  end
end
