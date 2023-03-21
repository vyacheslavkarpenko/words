class Language
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Attributes::Dynamic

  has_many :words

  # [
  #   {:main_attribute=>"english_usa", :detailed_attributes=>{"name"=>"English USA", "icon"=>"sdfsdfsdfsdf"}},
  #   {:main_attribute=>"english_great_britain", :detailed_attributes=>{"name"=>"English Great Britain", "icon"=>""}}
  # ]
  # при додавання до ямл файлу оновлювати записи в бд
  # при редагуванны ямл файлу оновлювати записи в бд
  # при видаленні з ямл файлу оновлювати записи в бд

  # додаю всі мови
  def self.assign(languages)
    # видаляю не актуальні мови
    delete_unused(languages)
    languages.each do |language|
      # створюю мову якщо немає
      founded_or_created = Language.where(main_attribute: language[:main_attribute]).first_or_create(main_attribute: language[:main_attribute], detailed_attributes: { name: language[:detailed_attributes]['name'], icon: language[:detailed_attributes]['icon'] })
      # оновлюю існуючу мову
      update_language(founded_or_created, language)
    end
  end

  def self.update_language(founded_or_created, language)
    if need_to_update?(founded_or_created, language)
      founded_or_created.update(detailed_attributes: { name: language[:detailed_attributes]['name'], icon: language[:detailed_attributes]['icon'] })
    end
  end

  def self.need_to_update?(founded_or_created, language)
    (founded_or_created[:detailed_attributes]['name'] != language[:detailed_attributes]['name']) || (founded_or_created[:detailed_attributes]['icon'] != language[:detailed_attributes]['icon'])
  end

  def self.languages
    @languages ||= Language.all().to_a
  end

  def self.delete_unused(languages)
    is_need_to_delete?(languages)
    unused_languages = db_main_attribute - file_main_attribute(languages)
    if unused_languages.size >= 1
      unused_languages.each do |unused_language|
        Language.find_by(main_attribute: unused_language).destroy
      end
    end
  end

  def self.is_need_to_delete?(languages)
    db_main_attribute != file_main_attribute(languages)
  end

  def self.db_main_attribute
    Language.all()&.to_a.map(&:main_attribute)
  end

  def self.file_main_attribute(languages)
    languages.map{|e| e[:main_attribute]}
  end
end
