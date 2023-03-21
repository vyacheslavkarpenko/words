class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email, type: String
  field :password, type: String

  has_one :account
  has_many :books
end
