class RecordingsController < ApplicationController
  before_action :set_recording, only: [:show, :edit, :update, :destroy]

  def index
    @recordings = Recording.all
  end

  def show
  end

  def new
    @recording = Recording.new
  end

  def edit
  end

  def create
    @recording = Recording.new(recording_params)
    open_tuner = @recording.check_for_open_tuner
    @recording.tuner = open_tuner

    respond_to do |format|
      if @recording.save
        format.html { redirect_to @recording, notice: 'Recording was successfully created.' }
        format.json { render :show, status: :created, location: @recording }
      else
        format.html { render :new }
        format.json { render json: @recording.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @recording.update(recording_params)
        format.html { redirect_to @recording, notice: 'Recording was successfully updated.' }
        format.json { render :show, status: :ok, location: @recording }
      else
        format.html { render :edit }
        format.json { render json: @recording.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @recording.destroy
    respond_to do |format|
      format.html { redirect_to recordings_url, notice: 'Recording was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_recording
      @recording = Recording.find(params[:id])
    end

    def recording_params
      params.require(:recording).permit(:start_time, :end_time, :channel, :video)
    end
end
