class Api::V1::UsersController < ActionController::API

  def create
    new_user = User.new(email: params[:email].downcase, password: params[:password], password_confirmation: params[:password], api_key: SecureRandom.hex)
    if new_user.save
      render json: #serializder
      status: 201
    end


  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

end
