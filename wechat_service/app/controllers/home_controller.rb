# encoding: utf-8
class HomeController < ApplicationController
  skip_before_filter :authenticate_user!
  layout '/layouts/home'

  def index
    App::T += 1
    @t = App::T
  end

  def about_us
  end

  def contact_us
  end
end
