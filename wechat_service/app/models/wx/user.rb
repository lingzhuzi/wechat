class Wx::User < ActiveRecord::Base
  belongs_to :app
  belongs_to :avatar
end
