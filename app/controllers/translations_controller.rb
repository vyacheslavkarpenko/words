class TranslationsController < ApplicationController
  before_action :set_translation, only: %i[ show edit update destroy ]

  # class PostsController < ApplicationController
  #   def index
  #     @posts = Post.all
  #     render turbo_stream: turbo_stream.replace('posts', partial: 'posts/list', locals: { posts: @posts })
  #   end
  # end


  # GET /user-translations/:user_id
  def user_translations
    book_translations = BookTranslation.where(book_id: params[:book_id], learned: params[:learned] || false)
    translations = book_translations.map do |book_translation|

      translation = Translation.find(book_translation.translation_id)
      words_by_language = translation.words.where(language_id: { '$in' => [@user_to_learn_language[:id], @user_native_language[:id]]})
      # next if words_by_language.map(&:language_id).uniq.size < 2
      translation
    end
    user_translations = translations.compact()
    @translations = []

    # Bulld correct object
    user_translations.map do |translation|
      new_translation_obj = { id: translation.id, native_words: [], to_learn_words: [] }
      translation.words.map do | word |
        word.language_id.to_s == @user_native_language[:id] ? new_translation_obj[:native_words].push(word) : new_translation_obj[:to_learn_words].push(word)
      end
      @translations.push(new_translation_obj)
      # binding.pry
    end
    # render turbo_stream: turbo_stream.replace('translations', template: 'translations/user_translations', locals: { translations: @user_translations })
    # binding.pry
    @book_name =  Book.find(params[:book_id]).name
  end

  def new_user_translation
    @new_user_translation = Translation.new()
  end

  def add_user_translation
    translation = Translation.create()

    learned_increment = -1
    learned_expressions = params[:translation][:learnedExpression]
    learned_transcriptions = params[:translation][:learnedTranscription]
    learned_language = params[:translation][:learnedLanguage]
    learned = learned_expressions.map do |expression|
      index = learned_increment+=1
      {
        expression: expression,
        transcription: learned_transcriptions[index],
        translation_id: translation.id,
        language_id: learned_language
      }
    end

    native_increment = -1
    native_expressions = params[:translation][:nativeExpression]
    native_transcription = params[:translation][:nativeTranscription]
    native_language = params[:translation][:nativeLanguage]
    native = native_expressions.map do |expression|
      index = native_increment+=1
      {
        expression: expression,
        transcription: native_transcription[index],
        translation_id: translation.id,
        language_id: native_language
      }
    end
# binding.pry
    words = learned + native
    book_translation = BookTranslation.create(book_id: params[:translation][:book_id], translation_id: translation._id)

    words.each do | word |
      Word.create(word)
    end
    respond_to do |format|
      format.html {redirect_to books_translations_path(user_id: params[:translation][:user_id], book_id: params[:translation][:book_id], learned: false, page: 1) }
      # format.turbo_stream
    end
  end

  # GET /translations or /translations.json
  def index
    @translations = Translation.all
  end

  # GET /translations/1 or /translations/1.json
  def show
  end

  # GET /translations/new
  def new
    @translation = Translation.new
  end

  # GET /translations/1/edit
  def edit
    # binding.pry
    @translation = Translation.find(params[:translation_id])

    @separated_words = {
      native: @translation.words.where(language_id: user_native_language[:id]).to_a,
      to_learn: @translation.words.where(language_id: user_to_learn_language[:id]).to_a,
    }
  end

  # POST /translations or /translations.json
  def create
    @translation = Translation.new(translation_params)

    respond_to do |format|
      if @translation.save
        # binding.pry
        format.html { redirect_to translation_url(@translation), notice: "Translation was successfully created." }
        format.json { render :show, status: :created, location: @translation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @translation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /translations/1 or /translations/1.json
  def update
    redirect_path = if params[:translation][:redirect_ater_translation_update] == '1'
      # binding.pry
      books_translations_path(user_id: params[:translation][:user_id], book_id: params[:translation][:book_id], learned: params[:translation][:learned], page: params[:translation][:page])
    else
      translations_edit_path(@current_user.id, params[:book_id], params[:translation_id])
    end

    respond_to do |format|
      if update_translation
        format.html { redirect_to redirect_path, notice: "Translation was successfully updated." }
        format.json { render :show, status: :ok, location: @translation }
      else
        format.html { redirect_to redirect_path, status: :unprocessable_entity }
        format.json { render json: @translation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /translations/1 or /translations/1.json
  def destroy
    @translation.destroy

    respond_to do |format|
      format.html { redirect_to translations_url, notice: "Translation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_translation
      # binding.pry
      @translation = Translation.find(params[:translation_id])
    end

    # Only allow a list of trusted parameters through.
    def translation_params
      # params.fetch(:translation, {})
      params.require(:translation).permit(:word, :translation_id, :book_id)
    end

    def update_translation
      # binding.pry
      new_translation_word = params[:translation][:word]

      if params[:translation][:word]
        new_translation_word.map do |word|
          # Word.create(expression: word, translation_id: params[:translation_id])
        end
      end

      params_data = Hashie::Mash.new(params[:translation])
      keys_for_delete = %w[redirect_ater_translation_update book_id user_id learned page]
      keys_for_delete.map{|v| params_data.delete(v)}

      # binding.pry
      # data
      # params_data ={
      #   "63f6309b755f850ca7a51ea5"=>["w1", "w1-", "63dd872b755f857cdd026f60"],
      #   "63f6309b755f850ca7a51ea6"=>["w2", "w2", "63dd872b755f857cdd026f60"],
      #   "63f6309b755f850ca7a51ea3"=>["t1", "t1-", "63dd872b755f857cdd026f5f"],
      #   "63f6309b755f850ca7a51ea4"=>["t2", "t2-", "63dd872b755f857cdd026f5f"]
      #   "0"                       =>["c2", "c2-", "63dd872b755f857cdd026f5f"]
      # }

      begin
        params_data.each do |key, value|
          expression, transcription, language_id = value
          data = {expression: expression, transcription: transcription, language_id: language_id}
            # binding.pry
          if BSON::ObjectId.legal?(key)
            Word.find(key).update!(data)
          else
            # binding.pry
            Word.create!(data.merge!(translation_id: params[:translation_id] ))
          end
        end
      rescue Mongoid::Errors::DocumentNotFound => e
        # binding.pry
        p e
        return false
      end
    end
end
