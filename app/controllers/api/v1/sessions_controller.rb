class Api::V1::SessionsController < ActionController::API
  before_action :check_params

  def login
    user = User.find_by(email: sessions_params[:email])
    if user && user.authenticate(sessions_params[:password])
      render json: UsersSerializer.new(user), status: 200
    else
      render json: {error: 'The email or password was incorrect'}, status: 400
    end

  end

  private

  def sessions_params
    params.permit(:email, :password)
  end

  def check_params
    if sessions_params[:email].empty? || sessions_params[:password].empty?
      render json: {error: "Please both an email and a password."}, status: 400
    end
  end
end
