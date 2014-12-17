# encoding: utf-8
class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]

  # GET /messages
  # GET /messages.json
  def index
    app = App.find(params[:app_id])
    @wx_users = app.wx_users
  end

  def all
    app = current_user.apps.find(params[:app_id])
    messages = app.messages.where('from_user_name = ? or to_user_name = ?', params[:user_open_id], params[:user_open_id])

    render json: {code: 1, messages: messages}
  end

  def send_message
    app = current_user.apps.find(params[:app_id])
    message = Wx::Common.build_text_message(params[:user_open_id], params[:message])
    save_message(message, app)
    logger.debug Time.now.to_f
    response = Wx::Api.send_message(app, message)
    logger.debug Time.now.to_f
    code = response['errcode'] == 0 ? 1 : 0

    render json: {code: code}
  end

  def save_message(message_hash, app)
    message = Message.new
    message.title          = ''
    message.content        = message_hash['text']['content']
    message.original       = message_hash.to_json
    message.message_type   = 'text'
    message.to_user_name   = message_hash['touser']
    message.from_user_name = app.wx_id
    message.app_id         = app.id
    message.author_id      = current_user.id
    message.save!

    return message
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params)

    respond_to do |format|
      if @message.save
        format.html { redirect_to @message, notice: 'Message was successfully created.' }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:to_user_name, :from_user_name, :create_time, :message_type, :content, :msg_id)
    end
end
