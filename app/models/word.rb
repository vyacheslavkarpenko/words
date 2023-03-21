class Word
  include Mongoid::Document
  include Mongoid::Timestamps

  # field :language, type: String
  field :expression, type: String
  field :transcription, type: String

  belongs_to :translation
  belongs_to :language

  def self.create_default_word(translation_id)
    create(expression: 'шукати', language: 'Українська', translation_id: translation_id)
    create(expression: 'look for', language: 'English', translation_id: translation_id)
  end
end
