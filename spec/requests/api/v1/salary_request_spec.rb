require 'rails_helper'

describe 'Salaries Requests' do
  describe 'obtains salaries - happy path' do
    it 'can obtain weather and salaries information' do

      get api_v1_salary_path, params: {location: "denver"}

      expect(response).to be_successful

      salary = JSON.parse(response.body, symbolize_names: true)

      expect(salary).to be_a(Hash)
      expect(salary.length).to eq(1)
      expect(salary).to have_key(:data)
      expect(salary[:data]).to be_a(Hash)
      expect(salary[:data].length).to eq(3)
      expect(salary[:data].keys).to match_array [:id, :type, :attributes]
      expect(salary[:data][:id]).to eq(nil)
      expect(salary[:data][:type]).to eq("salaries")
      expect(salary[:data][:attributes]).to be_a(Hash)
      expect(salary[:data][:attributes].length).to eq(3)
      expect(salary[:data].keys).to match_array [:destination, :forecast, :salaries]
      expect(salary[:data][:attributes][:destination].length).to eq(1)
      expect(salary[:data][:attributes][:destination]).to be_a(String)
      expect(salary[:data][:attributes][:forecast].length).to eq(2)
      expect(salary[:data][:attributes][:forecast].keys).to match_array [:summary, :temperature]
      expect(salary[:data][:attributes][:forecast][:summary]).to be_a(String)
      expect(salary[:data][:attributes][:forecast][:temperature]).to be_a(String)
      expect(salary[:data][:attributes][:salaries]).to be_an(Array)
      expect(salary[:data][:attributes][:salaries][0]).to be_a(Hash)
    end
  end
end
