require 'ostruct' #check if necessary

class Api::V1::ForecastsController < ActionController::API
  before_action :check_params

  def forecast
    forecast_data = ForecastsFacade.forecast(params[:location])

    if forecast_data == "Error search terms"
      render json: {error: "Please provide search terms."}, status: 400
    else
      render json: ForecastSerializer.new(forecast_data)
    end
  end

  private

  def check_params
    if params[:location].nil?
      render json: {error: "Please provide a query parameter and search terms."}, status: 400
    end
  end


end
