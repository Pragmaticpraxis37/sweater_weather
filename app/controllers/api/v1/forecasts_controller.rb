class Api::V1::ForecastsController < ActionController::API
  def forecast
    # conn_1 = Faraday.new(
    #   url: 'http://www.mapquestapi.com',
    #   params: {key: 'TTmP4GJnMSEgIJ5sd9JKFdSAqA0ZiviA'}
    # )

    conn_1 = Faraday.new(
      url: "#{ENV['MAP_QUEST_BASE_URL']}",
      params: {key: "#{ENV['MAP_QUEST_KEY']}"}
    )

    response_1 = conn_1.get('geocoding/v1/address') do |req|
      req.params['location'] = 'Denver,CO'
    end

    geodata = JSON.parse(response_1.body, symbolize_names: true)

    lat = geodata[:results][0][:locations][0][:latLng][:lat]
    lon = geodata[:results][0][:locations][0][:latLng][:lng]

    conn_2 = Faraday.new(
      url: "#{ENV['OPEN_WEATHER_BASE_URL']}",
      params: {appid: "#{ENV['OPEN_WEATHER_KEY']}"}
    )

    response_2 = conn_2.get('/data/2.5/onecall') do |req|
      req.params['lat'] = "#{lat}"
      req.params['lon'] = "#{lon}"
    end

    weather = JSON.parse(response_2.body, symbolize_names: true)

    require "pry"; binding.pry
  end
end


# conn_2 = Faraday.new(
#   url: 'https://api.openweathermap.org',
#   params: {appid: 'b3c5b8f6cfb0dccbc94d46c466cab9ab'}
# )
