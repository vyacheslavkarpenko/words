class BookTranslation
  include Mongoid::Document
  include Mongoid::Timestamps

  # after_update { broadcast_append_to 'todos' }

  field :learned, type: Boolean, default: false

  belongs_to :book
  belongs_to :translation

  def self.create_default_books_translations(user, book_for_translation)
    translation = Translation.create()
    word = Word.create_default_word(translation._id)
    create(book_id: book_for_translation._id, translation_id: translation._id)
  end
end

