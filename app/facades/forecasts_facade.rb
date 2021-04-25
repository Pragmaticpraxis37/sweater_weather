class ForecastsFacade

  def self.forecast(location)
    weather_data = ForecastsService.forecast(CoordinatesService.coordinates(location))
    forecast_data(weather_data)
  end

  def self.current_weather_data(weather)
    {
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
  end

  def self.daily_weather_data(weather)
    weather[:daily][0..4].map do |day|
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
  end

  def self.hourly_weather_data(weather)
    weather[:hourly][0..7].map do |hour|
      {
        time: Time.at(hour[:dt]).strftime("%H:%M:%S"),
        temp: hour[:temp],
        description: hour[:weather][0][:description],
        icon: hour[:weather][0][:icon]
      }
    end
  end

  def self.forecast_data(weather_data)
    current_weather_data = current_weather_data(weather_data)
    daily_weather_data = daily_weather_data(weather_data)
    hourly_weather_data = hourly_weather_data(weather_data)
    OpenStruct.new({
                    id: nil,
                    current_weather: current_weather_data,
                    daily_weather: daily_weather_data,
                    hourly_weather: hourly_weather_data
                  })
  end
end
