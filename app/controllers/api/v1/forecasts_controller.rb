class Api::V1::ForecastsController < ActionController::API
  def forecast
    # conn_1 = Faraday.new(
    #   url: 'http://www.mapquestapi.com',
    #   params: {key: 'TTmP4GJnMSEgIJ5sd9JKFdSAqA0ZiviA'}
    # )

    location = params[:location]

    conn_1 = Faraday.new(
      url: "#{ENV['MAP_QUEST_BASE_URL']}",
      params: {key: "#{ENV['MAP_QUEST_KEY']}"}
    )

    response_1 = conn_1.get('geocoding/v1/address') do |req|
      req.params['location'] = "#{location}"
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
      req.params['units'] = 'imperial'
    end

    weather = JSON.parse(response_2.body, symbolize_names: true)

    current_weather = weather[:current]


    datetime = Time.at(current_weather[:dt])
    sunrise = Time.at(current_weather[:sunrise])
    sunset = Time.at(current_weather[:sunset])
    temperature = current_weather[:temp]
    feels_like = current_weather[:feels_like]
    pressure = current_weather[:pressure]
    humidity = current_weather[:humidity]
    uvi = current_weather[:uvi]
    visibility = current_weather[:visibility]
    description = current_weather[:weather][0][:description]
    icon = current_weather[:weather][0][:icon]

    # require "pry"; binding.pry
    hourly_weather = weather[:hourly][0..7]

    eight_hours = []



    # require "pry"; binding.pry


    hourly_weather.each do |hour|
      require "pry"; binding.pry
      eight_hours << [:datetime] = Time.at(hour[:dt])
      # eight_hours[:temp] = hour[:temp]
      # eight_hours[:conditions] = hour[:weather][0][:description]
      # eight_hours[:conditions] = hour[:weather][0][:icon]
    end

    require "pry"; binding.pry

end


# conn_2 = Faraday.new(
#   url: 'https://api.openweathermap.org',
#   params: {appid: 'b3c5b8f6cfb0dccbc94d46c466cab9ab'}
# )
