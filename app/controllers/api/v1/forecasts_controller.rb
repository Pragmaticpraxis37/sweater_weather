require 'ostruct'

class Api::V1::ForecastsController < ActionController::API
  def forecast
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




    current_weather_data = {
                        datetime: Time.at(weather[:current][:dt]),
                        sunrise: Time.at(weather[:current][:sunrise]),
                        sunset: Time.at(weather[:current][:sunset]),
                        temperature: weather[:current][:temp],
                        feels_like: weather[:current][:feels_like],
                        humidity: weather[:current][:humidity],
                        uvi: weather[:current][:uvi],
                        visibility: weather[:current][:visibility],
                        conditions: weather[:current][:weather][0][:description],
                        icon: weather[:current][:weather][0][:icon]
                      }



    daily_weather_data = weather[:daily][0..4].map do |day|
                                    {
                                      date: Time.at(day[:dt]).strftime("%m-%e-%y"),
                                      sunrise: Time.at(day[:sunrise]),
                                      sunset: Time.at(day[:sunset]),
                                      max_temp: day[:temp][:max],
                                      min_temp: day[:temp][:min],
                                      conditions: day[:weather][0][:description],
                                      icon: day[:weather][0][:icon]
                                    }
                        end


    hourly_weather_data = weather[:hourly][0..7].map do |hour|
                    {
                                    time: Time.at(hour[:dt]).strftime("%H:%M:%S"),
                                    temp: hour[:temp],
                                    description: hour[:weather][0][:description],
                                    icon: hour[:weather][0][:icon]
                      }
                  end


    forecast = OpenStruct.new({
                                id: nil,
                                current_weather: current_weather_data,
                                daily_weather: daily_weather_data,
                                hourly_weather: hourly_weather_data
                              })



    render json: ForecastSerializer.new(forecast)
  end
end








# current_weather = weather[:current]


# datetime = Time.at(current_weather[:dt])
# sunrise = Time.at(current_weather[:sunrise])
# sunset = Time.at(current_weather[:sunset])
# temperature = current_weather[:temp]
# feels_like = current_weather[:feels_like]
# pressure = current_weather[:pressure]
# humidity = current_weather[:humidity]
# uvi = current_weather[:uvi]
# visibility = current_weather[:visibility]
# description = current_weather[:weather][0][:description]
# icon = current_weather[:weather][0][:icon]
