class Api::V1::UsersController < ActionController::API

  def create
    new_user = User.new(email: user_params[:email].downcase, password: user_params[:password], password_confirmation: params[:password_confirmation], api_key: SecureRandom.hex)
    if new_user.save
      render json: UsersSerializer.new(new_user), status: 201
    else
      render json: {error: new_user.errors.full_messages}, status: 400
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end

end
