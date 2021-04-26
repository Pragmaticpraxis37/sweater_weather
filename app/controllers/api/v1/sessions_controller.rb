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


# new_user = User.new(email: user_params[:email].downcase, password: user_params[:password], password_confirmation: params[:password_confirmation], api_key: SecureRandom.hex)
# if new_user.save
#   render json: UsersSerializer.new(new_user), status: 201
# else
#   render json: {error: new_user.errors.full_messages}, status: 400
# end
# end
#
# private
#
# def user_params
# params.permit(:email, :password, :password_confirmation)
# end
