class Wx::FilesController < ApplicationController
  before_action :set_wx_file, only: [:show, :edit, :update, :destroy]

  # GET /wx/files
  # GET /wx/files.json
  def index
    @wx_files = Wx::File.all
  end

  # GET /wx/files/1
  # GET /wx/files/1.json
  def show
  end

  # GET /wx/files/new
  def new
    @wx_file = Wx::File.new
  end

  # GET /wx/files/1/edit
  def edit
  end

  # POST /wx/files
  # POST /wx/files.json
  def create
    @wx_file = Wx::File.new(wx_file_params)

    respond_to do |format|
      if @wx_file.save
        format.html { redirect_to @wx_file, notice: 'File was successfully created.' }
        format.json { render :show, status: :created, location: @wx_file }
      else
        format.html { render :new }
        format.json { render json: @wx_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wx/files/1
  # PATCH/PUT /wx/files/1.json
  def update
    respond_to do |format|
      if @wx_file.update(wx_file_params)
        format.html { redirect_to @wx_file, notice: 'File was successfully updated.' }
        format.json { render :show, status: :ok, location: @wx_file }
      else
        format.html { render :edit }
        format.json { render json: @wx_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /wx/files/1
  # DELETE /wx/files/1.json
  def destroy
    @wx_file.destroy
    respond_to do |format|
      format.html { redirect_to wx_files_url, notice: 'File was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_wx_file
      @wx_file = Wx::File.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def wx_file_params
      params.require(:wx_file).permit(:file_name, :file_size, :mime_type, :digest, :description)
    end
end
