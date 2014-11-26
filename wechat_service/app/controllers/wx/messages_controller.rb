class Wx::MessagesController < ApplicationController
  before_action :set_wx_message, only: [:show, :edit, :update, :destroy]

  # GET /wx/messages
  # GET /wx/messages.json
  def index
    @wx_messages = Wx::Message.all
  end

  # GET /wx/messages/1
  # GET /wx/messages/1.json
  def show
  end

  # GET /wx/messages/new
  def new
    @wx_message = Wx::Message.new
  end

  # GET /wx/messages/1/edit
  def edit
  end

  # POST /wx/messages
  # POST /wx/messages.json
  def create
    @wx_message = Wx::Message.new(wx_message_params)

    respond_to do |format|
      if @wx_message.save
        format.html { redirect_to @wx_message, notice: 'Message was successfully created.' }
        format.json { render :show, status: :created, location: @wx_message }
      else
        format.html { render :new }
        format.json { render json: @wx_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wx/messages/1
  # PATCH/PUT /wx/messages/1.json
  def update
    respond_to do |format|
      if @wx_message.update(wx_message_params)
        format.html { redirect_to @wx_message, notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @wx_message }
      else
        format.html { render :edit }
        format.json { render json: @wx_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wx/messages/1
  # DELETE /wx/messages/1.json
  def destroy
    @wx_message.destroy
    respond_to do |format|
      format.html { redirect_to wx_messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wx_message
      @wx_message = Wx::Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wx_message_params
      params.require(:wx_message).permit(:to_user_name, :from_user_name, :create_time, :message_type, :content, :msg_id)
    end
end
