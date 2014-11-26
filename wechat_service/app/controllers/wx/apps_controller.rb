class Wx::AppsController < ApplicationController
  before_action :set_wx_app, only: [:show, :edit, :update, :destroy]

  # GET /wx/apps
  # GET /wx/apps.json
  def index
    @wx_apps = Wx::App.all
  end

  # GET /wx/apps/1
  # GET /wx/apps/1.json
  def show
  end

  # GET /wx/apps/new
  def new
    @wx_app = Wx::App.new
  end

  # GET /wx/apps/1/edit
  def edit
  end

  # POST /wx/apps
  # POST /wx/apps.json
  def create
    @wx_app = Wx::App.new(wx_app_params)

    respond_to do |format|
      if @wx_app.save
        format.html { redirect_to @wx_app, notice: 'App was successfully created.' }
        format.json { render :show, status: :created, location: @wx_app }
      else
        format.html { render :new }
        format.json { render json: @wx_app.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wx/apps/1
  # PATCH/PUT /wx/apps/1.json
  def update
    respond_to do |format|
      if @wx_app.update(wx_app_params)
        format.html { redirect_to @wx_app, notice: 'App was successfully updated.' }
        format.json { render :show, status: :ok, location: @wx_app }
      else
        format.html { render :edit }
        format.json { render json: @wx_app.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wx/apps/1
  # DELETE /wx/apps/1.json
  def destroy
    @wx_app.destroy
    respond_to do |format|
      format.html { redirect_to wx_apps_url, notice: 'App was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wx_app
      @wx_app = Wx::App.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wx_app_params
      params.require(:wx_app).permit(:name, :icon_id, :wx_id, :app_id, :sceret, :token)
    end
end
