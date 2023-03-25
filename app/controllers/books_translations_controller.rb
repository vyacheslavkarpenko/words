class BooksTranslationsController < ApplicationController
  def change_learned_status
    book_translation ||= BookTranslation.where(translation_id: params[:translation_id], book_id: params[:book_id])
    # book_translation.update(learned: params[:status])
    # redirect_back(fallback_location: user_translations_path(user_id: current_user._id, book_id: params[:book_id])) and return

    respond_to do |format|
      # binding.pry
      if book_translation.update(learned: params[:status])
        # binding.pry
        translation_id = "translation-#{book_translation.first.translation_id}"
        format.turbo_stream { render turbo_stream: turbo_stream.remove(translation_id) }
        # format.html { redirect_back(fallback_location: books_translations_path(user_id: current_user._id, book_id: params[:book_id])) }
      else
        # format.html { render :edit, status: :unprocessable_entity }
      end
    end


  end

  def remove_from_user_book
    book_translation = BookTranslation.where(translation_id: params[:translation_id], book_id: params[:book_id])
    # book_translation.destroy()
    translation_id = "translation-#{book_translation.first.translation_id}"

    respond_to do |format|
      if book_translation.destroy()
      # binding.pry
        format.turbo_stream { render turbo_stream: turbo_stream.remove(translation_id) }
      end
    end
    # redirect_back(fallback_location: user_translations_path(user_id: current_user._id, book_id: params[:book_id])) and return
  end

  # books_translations GET  /users/:user_id/books/:book_id/translations(.:format)  books_translations#books_translations
  # https://www.bearer.com/blog/infinite-scrolling-pagination-hotwire
  def books_translations
    # Pagination
    # binding.pry
    limit = @current_account.translations_per_page
    @count = BookTranslation.where(book_id: params[:book_id], learned: params[:learned] || false).count
    @pages = (@count.to_f/limit).ceil
    skip = limit * (params[:page].to_i - 1)

    # Get book translations by book id.
    book_translations = BookTranslation.where(book_id: params[:book_id], learned: params[:learned] || false).limit(limit).skip(skip)

    # Translations by translation id
    translations = book_translations.map do |book_translation|
      translation = Translation.find(book_translation.translation_id)
      words_by_language = translation.words.where(language_id: { '$in' => [@user_to_learn_language[:id], @user_native_language[:id]]})
      # next if words_by_language.map(&:language_id).uniq.size < 2
      translation
    end

    # Bulld correct object
    @books_translations = []
    translations.compact().map do |translation|
      new_translation_obj = { id: translation.id, native_words: [], to_learn_words: [] }
      translation.words.map do | word |
        word.language_id.to_s == @user_native_language[:id] ? new_translation_obj[:native_words].push(word) : new_translation_obj[:to_learn_words].push(word)
      end
      @books_translations.push(new_translation_obj)
    end

    @book_name =  Book.find(params[:book_id]).name
    # respond_to do |format|
    #   format.html # GET
    #   format.turbo_stream # POST
    # end
  end

  def turbo_test
  #   render turbo_stream: turbo_stream.update(
  #     'turbo-test',
  #      partial: "turbo_test",
  #      locals: { a: "Hello, World!" }
  #  )
  #  respond_to do |format|
    
  #   # binding.pry
    
  #   format.turbo_stream { render turbo_stream: turbo_stream.update("turbo-test", partial: "turbo_test", locals: { my_var: "world" } ) }
  #   format.html
  #  end
  end
end
