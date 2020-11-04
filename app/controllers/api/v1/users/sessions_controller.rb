class Api::V1::Users::SessionsController < Api::V1::Users::AppController
  skip_before_action :set_current_user_from_header, only: [:sign_in, :sign_up]

  def sign_in
    user = User.find_by_email(params[:user][:email])
    raise GKError.new("Invalid email") if user.blank?
    if user.valid_password?(params[:user][:password])
      render json: { success: true, user: user.as_json_with_jwt }
    else
      raise GKAuthenticationError.new("Invalid email or password")
    end
  end

  def sign_up
    user = User.new(user_params)
    if user.save
      render json: { user: user.as_profile_json }
    else
      raise GKError.new("Email duplicate")
    end
  end

  def sign_out
    current_user.generate_auth_token
    current_user.save
    render json: { success: true }
  end

  def me
    render json: { success: true, user: current_user.as_profile_json }
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :first_name, :last_name)
  end
end
