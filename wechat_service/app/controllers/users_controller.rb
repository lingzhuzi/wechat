class Wx::UsersController < ApplicationController
  before_action :set_wx_user, only: [:show, :edit, :update, :destroy]

  # GET /wx/users
  # GET /wx/users.json
  def index
    @wx_users = Wx::User.all
  end

  # GET /wx/users/1
  # GET /wx/users/1.json
  def show
  end

  # GET /wx/users/new
  def new
    @wx_user = Wx::User.new
  end

  # GET /wx/users/1/edit
  def edit
  end

  # POST /wx/users
  # POST /wx/users.json
  def create
    @wx_user = Wx::User.new(wx_user_params)

    respond_to do |format|
      if @wx_user.save
        format.html { redirect_to @wx_user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @wx_user }
      else
        format.html { render :new }
        format.json { render json: @wx_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wx/users/1
  # PATCH/PUT /wx/users/1.json
  def update
    respond_to do |format|
      if @wx_user.update(wx_user_params)
        format.html { redirect_to @wx_user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @wx_user }
      else
        format.html { render :edit }
        format.json { render json: @wx_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wx/users/1
  # DELETE /wx/users/1.json
  def destroy
    @wx_user.destroy
    respond_to do |format|
      format.html { redirect_to wx_users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wx_user
      @wx_user = Wx::User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wx_user_params
      params.require(:wx_user).permit(:nick_name, :remark_name, :open_id, :app_id, :avatar_id, :description)
    end
end
