# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  auth_token             :string
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  failed_attempts        :integer          default(0), not null
#  first_name             :text
#  last_name              :text
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  locked_at              :datetime
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string
#  unlock_token           :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_auth_token            (auth_token)
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :lockable, :trackable, :timeoutable

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
