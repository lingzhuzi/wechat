# encoding: utf-8
class WxController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:index]
  before_filter :check_signature
  protect_from_forgery except: :index

  def index
    wx_message = Wx::Common.get_wx_message(request)
    Wx::Processor.delay.deal(@wx_app, wx_message)

    render text: ''
  end

  private

  def check_signature
    @wx_app = App.find(params[:id] || 1)
    text    = Wx::Common.check_signature(@wx_app, params)
    if text.present?
      render :text => text
      return
    end
  rescue => e
    logger.error e.message
    logger.error e.backtrace.join("\n")
    render :text => 'Signature Error! see log for more infomation.'
    return
  end

end