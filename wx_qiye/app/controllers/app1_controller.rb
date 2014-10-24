# encoding: utf-8
class App1Controller < ApplicationController
  before_filter :wx_crypt, :verify_url, :only => [:index]

  def index
    message = WxCommon.decrypt_message(@wx_crypt, params, request)
    logger.debug "----> message: #{message}"
    xml_content =  "<ToUserName><![CDATA[#{message['xml']['FromUserName']}]]</ToUserName>"
    xml_content << "<FromUserName><![CDATA[#{message['xml']['ToUserName']}]]</FromUserName>"
    xml_content << "<CreateTime><![CDATA[#{Time.now.to_i}]]</CreateTime>"
    xml_content << "<MsgType><![CDATA[text]]></MsgType>"
    xml_content << "<Content><![CDATA[123]]></Content>"
    xml = "<xml>#{xml_content}</xml>"

    encrypt_message = @wx_crypt.encrypt_message(xml, params[:timestamp], params[:nonce])
logger.debug "----> encrypt_message: #{encrypt_message}"
    render text: encrypt_message
  end

  private

  def wx_crypt
    wx_id            = 'wxfe78d21152356457'
    token            = 'yunfis1'
    encoding_aes_key = 'qz2OCpKui4rkYxGHraC2czyZgmANLwrOodvIfztlSMd'
    @wx_crypt         = WxCrypt.new(token, encoding_aes_key, wx_id)
  end

  def verify_url
    signature     = params[:msg_signature]
    timestamp     = params[:timestamp]
    nonce         = params[:nonce]
    param_echostr = params[:echostr]

    if param_echostr.present?
      echostr = @wx_crypt.verify_url(signature, timestamp, nonce, param_echostr)
      render text:  echostr
      return false
    end
  end

end