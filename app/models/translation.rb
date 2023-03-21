class Translation
  include Mongoid::Document
  include Mongoid::Timestamps

  has_many :book_translations
  has_many :words
end
