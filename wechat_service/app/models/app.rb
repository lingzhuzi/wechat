# encoding: utf-8
class App < ActiveRecord::Base
  has_many :user_app_records
  has_many :users, through: :user_app_records
  has_many :wx_users, class_name: 'User'
  has_many :messages
  has_many :key_words

  belongs_to :icon

  T = 0
end
