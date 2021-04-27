class Api::V1::TripsController < ActionController::API
  before_action :check_params, :confirm_api_key


  @@hourly_data = nil
  @@daily_data = nil

  def trip
    trip_data = CoordinatesService.directions(trip_params[:origin], trip_params[:destination])

    trip_time_data = trip_data[:route][:realTime]
    trip_time = time(trip_time_data)


    dest_lat_and_lon = trip_data[:route][:locations][1][:latLng]

    start_city = start_city(trip_data[:route][:locations][0])
    end_city = end_city(trip_data[:route][:locations][1])

    weather_data = ForecastsService.forecast([dest_lat_and_lon[:lat], dest_lat_and_lon[:lng]])

    @@hourly_data = weather_data[:hourly]
    @@daily_data = weather_data[:daily]

    require "pry"; binding.pry

    weather_at_eta = weather_at_destination(trip_time_data)


    collection(start_city, end_city, trip_time, weather_at_eta)
    require "pry"; binding.pry
  end

  def start_city(start_city_data)
    city = start_city_data[:adminArea5]
    state = start_city_data[:adminArea3]
    country = start_city_data[:adminArea1]
    "#{city}, #{state}, #{country}"
  end

  def end_city(end_city_data)
    city = end_city_data[:adminArea5]
    state = end_city_data[:adminArea3]
    country = end_city_data[:adminArea1]
    "#{city}, #{state}, #{country}"
  end

  def weather_at_destination(trip_time_data)
    if trip_time_data < 172800
      hourly_weather_at_destination(trip_time_data)
    elsif trip_time_data < 691200
      daily_weather_at_destination(trip_time_data)
    else
      {temperature: "Your eta is outside of available temperature data.", conditions: "Your eta is outside of available conditions data."}
    end
  end

  def hourly_weather_at_destination(trip_time_data)
    hour = (((trip_time_data / 3600.0).round) - 1)
    {temperature: @@hourly_data[hour][:temp], conditions: @@hourly_data[hour][:weather][0][:description]}
  end

  def daily_weather_at_destination(trip_time_data)
    require "pry"; binding.pry
    day = ((trip_time_data / 86400) - 1)
    day_time = (trip_time_data / 86400.0).truncate(2)
    time_of_day = time_of_day(day_time)
    require "pry"; binding.pry
    {temperature: @@daily_data[day][:temp][time_of_day[0]], conditions: @@daily_data[day][:weather][0][:description]}
  end

  def time_of_day(day_time)
    day_time = day_time.to_s.split(".")[1].to_i
    if day_time <= 25
      time = [:morn]
    elsif day_time <= 50
      time = [:day]
    elsif day_time <= 75
      time = [:eve]
    else
      time = [:night]
    end
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

  def collection(start_city, end_city, travel_time, weather_at_eta)
    OpenStruct.new({
                    id: nil,
                    start_city: start_city,
                    end_city: end_city,
                    travel_time: travel_time,
                    weather_at_eta: weather_at_eta,
                  })
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
