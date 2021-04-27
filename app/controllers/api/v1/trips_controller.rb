class Api::V1::TripsController < ActionController::API
  before_action :check_params, :confirm_api_key


  def trip



    trip_data = CoordinatesService.directions(trip_params[:origin], trip_params[:destination])

    trip_time = trip_data[:route][:realTime]

    dest_lat_and_lon = trip_data[:route][:locations][0][:latLng]




    weather_data = ForecastsService.forecast([dest_lat_and_lon[:lat], dest_lat_and_lon[:lng]])
    hourly_data = weather_data[:hourly]
    daily_data = weather_data[:daily]
    # weather_data = ForecastsService.forecast(coordinates)

    # seconds in a day = 172800

    require "pry"; binding.pry

  end

  def time(trip_time)
    if trip_time < 3600
      "0 hours and #{(trip_time / 60).round.to_i} minutes"
    elsif (trip_time % 3600.0) < 60
      "#{(trip_time / 3600.0).round.to_i} hour(s) and 0 minutes"
    else
      "#{(trip_time / 3600.0).round.to_i} hour(s) and #{((trip_time % 3600) / 60).round.to_i} minutes"
    end
  end



  private

  # Should a begin and end default be set?
  # def check_params
  #
  # end

  def check_params
    if trip_params[:origin].empty?
      render json: {error: "Please provide an origin"}, status: 400
    elsif trip_params[:destination].empty?
      render json: {error: "Please provide a destination"}, status: 400
    elsif trip_params[:api_key].empty?
      render json: {error: "Please provide an API key"}, status: 401
    end
  end

  def confirm_api_key
    if !User.find_by(api_key: params[:api_key])
      render json: {error: "Unathorized"}, status: 401
    end
  end

  def trip_params
    params.permit(:origin, :destination, :api_key)
  end

end
