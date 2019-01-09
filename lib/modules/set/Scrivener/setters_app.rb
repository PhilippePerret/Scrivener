# frozen_string_literal: true
# # encoding: UTF-8

class Scrivener
class << self

  def set_lang value
    if I18n.available_locales.include?(value.to_sym)
      self.preferences.set({lang: value}, {save: true})
    else
      raise ArgumentError, t('preferences.errors.unavailable_language')
    end
  end

end #/ << self
end #/ Scrivener
