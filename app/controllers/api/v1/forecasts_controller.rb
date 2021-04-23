class Api::V1::ForecastsController < ActionController::API
  def forecast
    conn = Faraday.new(
      url: 'http://www.mapquestapi.com',
      params: {key: 'TTmP4GJnMSEgIJ5sd9JKFdSAqA0ZiviA'}
    )

    response = conn.get('geocoding/v1/address') do |req|
      req.params['location'] = 'Denver,CO'
    end

    geodata = JSON.parse(response.body, symbolize_names: true)

    lat_lng = geodata[:results][0][:locations][0][:latLng]
  end
end
