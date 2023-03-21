class WordsController < ApplicationController
  before_action :set_word, only: %i[ show edit update destroy ]

  # GET /records or /records.json
  # def index
  #   @records = Words.all
  # end

  # GET /records/1 or /records/1.json
  # def show
  # end

  # GET /records/new
  # def new
  #   # binding.pry
  #   @word = Word.new
  # end

  # GET /records/1/edit
  # def edit
  # end

  # POST /records or /records.json
  # def create
  #   @record = Words.new(record_params)

  #   respond_to do |format|
  #     if @record.save
  #       format.html { redirect_to record_url(@record), notice: "Record was successfully created." }
  #       format.json { render :show, status: :created, location: @record }
  #     else
  #       format.html { render :new, status: :unprocessable_entity }
  #       format.json { render json: @record.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /records/1 or /records/1.json
  # def update
  #   respond_to do |format|
  #     if @record.update(record_params)
  #       format.html { redirect_to record_url(@record), notice: "Record was successfully updated." }
  #       format.json { render :show, status: :ok, location: @record }
  #     else
  #       format.html { render :edit, status: :unprocessable_entity }
  #       format.json { render json: @record.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /records/1 or /records/1.json
  def destroy
    # binding.pry

    {notice: "Record was successfully destroyed."} if @word.destroy
    respond_to do |format|
      format.html { redirect_to records_url, notice: "Record was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_word
      @word = Word.find(params[:word_id])
    end

    # Only allow a list of trusted parameters through.
    def word_params
      params.require(:word).permit(:word, :transcription, :word_id)
    end
end
