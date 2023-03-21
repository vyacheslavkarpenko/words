class Todo
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Enum
  validates :title, presence: true
  validates :description, presence: true


  field :title, type: String
  field :description, type: String
  enum :status, [:incomplete, :complete]
end
