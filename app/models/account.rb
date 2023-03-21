class Account
  include Mongoid::Document
  include Mongoid::Timestamps

  field :languages, type: Hash, default: { native: '', to_learn: '' }
  field :redirect_ater_translation_update, type: Boolean, default: true
  field :translations_per_page, type: Integer, default: 5


  belongs_to :user

  def init_setting
    languages = Language.all().to_a
    # binding.pry
    self.languages[:native] = languages.first[:id]
    self.languages[:to_learn] = languages.second[:id]
    self.save!()
  end
end
