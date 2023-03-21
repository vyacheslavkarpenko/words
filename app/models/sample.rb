class Sample
  include Mongoid::Document
  include Mongoid::Timestamps

  field :sentence, type: String

end
