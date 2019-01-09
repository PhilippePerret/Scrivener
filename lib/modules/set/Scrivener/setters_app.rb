# frozen_string_literal: true
# # encoding: UTF-8

class Scrivener
  CORRESPONDANCES_LANGUES = {
    'fr' => 'fr', 'france' => 'fr', 'français' => 'fr', 'french' => 'fr',
    'en' => 'en', 'us' => 'en', 'anglais' => 'en', 'english' => 'en',
    'american' => 'en',
    'de' => 'de', 'deutsh' => 'de', 'allemand' => 'de'
  }
class << self

  def set_lang value
    value = CORRESPONDANCES_LANGUES[value] || value
    if I18n.available_locales.include?(value.to_sym)
      self.preferences.set({lang: value}, {save: true})
      ENV['SCRIV_LANG'] = value
      I18n.default_locale = @lang = value.to_sym
      wt('notices.change_lang_ok', nil, {air: true, color: :bleu})
      puts "-- ENV['SCRIV_LANG'] a été mis à #{ENV['SCRIV_LANG'].inspect}"
    else
      # Raise translation
      rt('preferences.errors.unavailable_language', {lang: value}, ArgumentError)
    end
  end

end #/ << self
end #/ Scrivener
