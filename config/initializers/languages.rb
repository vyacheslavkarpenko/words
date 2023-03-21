
Rails.application.config.to_prepare do
  languages_from_file = YAML.load_file(Rails.root.join('config/languages.yml'))
  languages = languages_from_file.map{|key, value| { main_attribute: key, detailed_attributes: value } }

  Language.assign(languages)
end
