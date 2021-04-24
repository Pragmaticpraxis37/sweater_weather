require 'ostruct'

class Api::V1::ForecastsController < ActionController::API
  def forecast
    forecast_data = ForecastsFacade.forecast(params[:location])
    # require "pry"; binding.pry
    render json: ForecastSerializer.new(forecast_data)
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
