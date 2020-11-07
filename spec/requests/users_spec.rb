require 'swagger_helper'

RSpec.describe '/users', type: :request do
  path '/oauth/token' do
    post 'Obtain Access Token' do
      tags 'Access Token'
      description 'Obtain Access Token'
      consumes 'application/json'
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
        user = FactoryBot.create(:user)
        let(:details) { { grant_type: 'password', email: user.email, password: 'password'} }
        run_test!
      end

      response '400', 'Returns unauthorized' do
        user = FactoryBot.create(:user)
        let(:details) { { grant_type: 'password', email: user.email, password: 'asd'} }
        run_test!
      end
    end
  end
end
