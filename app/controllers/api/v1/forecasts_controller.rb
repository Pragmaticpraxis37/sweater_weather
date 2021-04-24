require 'ostruct'

class Api::V1::ForecastsController < ActionController::API
  def forecast
    forecast_data = ForecastsFacade.forecast(params[:location])
    render json: ForecastSerializer.new(forecast_data)
  end
end
