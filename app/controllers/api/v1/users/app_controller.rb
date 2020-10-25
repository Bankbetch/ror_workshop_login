class Api::V1::Users::AppController < Api::AppController
  before_action :set_current_user_from_header

  def set_current_user_from_header
    auth_headers = request.headers["Authorization"]
    jwt = auth_headers.split(" ").last rescue nil
    results = JWT.decode(jwt, Rails.application.credentials.secret_key_base, true, { algorithm: "HS256" })
    payload = results.first rescue nil
    @current_user = User.find_by_auth_token(payload["auth_token"]) rescue nil
  end

  def current_user(auth = true)
    raise GKAuthenticationError.new("Not logged in or invalid auth token") if auth && @current_user.blank?
    @current_user
  end
end
