require 'rails_helper'

describe 'Users Requests - Create' do
  describe 'creates a user - happy path' do
    it 'can create a user' do

      body = ({
                  email: 'jabba@hutt.com',
                  password: 'hatesolo',
                  password_confirmation: 'hatesolo'
                })

      headers = {"CONTENT_TYPE" => "application/json"}
      post api_v1_users_path, headers: headers, params: body, as: :json

      require "pry"; binding.pry

      user = User.find_by(email: 'jabba@hutt.com')

      expect(user.email).to eq('jabba@hutt.com')
      expect(user.password).to eq('hatesolo')
    end
  end
end
