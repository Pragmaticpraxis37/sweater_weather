class Api::V1::TripsController < ActionController::API
  before_action :check_params, :confirm_api_key

  def trip
    serialized_collection = TripsFacade.collection(trip_params[:origin], trip_params[:destination])

    render json: RoadtripSerializer.new(serialized_collection)
  end

  private

  def check_params
    if trip_params[:origin].empty?
      render json: {error: "Please provide an origin."}, status: 400
    elsif trip_params[:destination].empty?
      render json: {error: "Please provide a destination."}, status: 400
    elsif trip_params[:api_key].empty?
      render json: {error: "Please provide an API key."}, status: 401
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
