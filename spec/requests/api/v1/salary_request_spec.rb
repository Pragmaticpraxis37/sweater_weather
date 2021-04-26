require 'rails_helper'

describe 'Salaries Requests' do
  describe 'obtains salaries - happy path' do
    it 'can obtain weather and salaries information' do

      get api_v1_salaries_path, params: {destination: "denver"}

      expect(response).to be_successful

      salaries = JSON.parse(response.body, symbolize_names: true)


      expect(salaries).to be_a(Hash)
      expect(salaries.length).to eq(1)
      expect(salaries).to have_key(:data)
      expect(salaries[:data]).to be_a(Hash)
      expect(salaries[:data].length).to eq(3)
      expect(salaries[:data].keys).to match_array [:id, :type, :attributes]
      expect(salaries[:data][:id]).to eq(nil)
      expect(salaries[:data][:type]).to eq("salaries")
      expect(salaries[:data][:attributes]).to be_a(Hash)
      expect(salaries[:data][:attributes].length).to eq(3)
      expect(salaries[:data][:attributes].keys).to match_array [:destination, :forecast, :salaries]
      expect(salaries[:data][:attributes][:destination]).to be_a(String)
      expect(salaries[:data][:attributes][:forecast].length).to eq(2)
      expect(salaries[:data][:attributes][:forecast].keys).to match_array [:summary, :temperature]
      expect(salaries[:data][:attributes][:forecast][:summary]).to be_a(String)
      expect(salaries[:data][:attributes][:forecast][:temperature]).to be_a(String)
      expect(salaries[:data][:attributes][:salaries]).to be_an(Array)

      salaries[:data][:attributes][:salaries].each do |job|
        expect(job).to be_a(Hash)
        expect(job.length).to eq(3)
        expect(job.keys).to match_array [:title, :min, :max]
        expect(job[:title]).to be_a(String)
        expect(job[:min]).to be_a(String)
        expect(job[:max]).to be_a(String)
      end

    end
  end
end
