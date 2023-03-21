class Book
  include Mongoid::Document
  include Mongoid::Timestamps
    validates :name, presence: true
    validates :is_multi_language, presence: true


  field :name, type: String
  field :is_multi_language, type: Boolean, default: true
  field :parent_id, type: BSON::ObjectId

  belongs_to :user
  has_many :book_translations

  def self.create_user_books(user)
    book_for_translation = create!(name: 'Translations', user_id: user._id)
    create!(name: 'Examples', user_id: user._id)
    BookTranslation.create_default_books_translations(user, book_for_translation)
  end
end