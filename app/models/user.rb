class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  def jwt(exp = 1.days.from_now) # ถ้าไม่ส่งจะเอาค่านี้ไปใช้
    JWT.encode({ auth_token: self.auth_token, exp: exp.to_i }, Rails.application.credentials.secret_key_base, "HS256")
  end

  before_create :generate_auth_token

  def generate_auth_token
    self.auth_token = SecureRandom.uuid # generate uuid
  end

  def as_json_with_jwt
    json = {}
    json[:first_name] = self.first_name
    json[:last_name] = self.last_name
    json[:email] = self.email
    json[:auth_jwt] = self.jwt(2.days.from_now) # (ค่าตัวแปรที่ส่งเข้าไปใหม่ถ้าไม่ส่งก็ใช้ค่าข้างบน)
    json
  end

  def as_profile_json
    json = {}
    json[:first_name] = self.first_name
    json[:last_name] = self.last_name
    json[:email] = self.email
    json
  end
end
