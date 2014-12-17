# encoding: utf-8
class User < ActiveRecord::Base
  has_many :user_app_records
  has_many :apps, through: :user_app_records
  belongs_to :app
  belongs_to :avatar
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

end
