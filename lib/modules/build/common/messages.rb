# frozen_string_literal: true
# encoding: UTF-8
class Scrivener
ERRORS[:build]  ||= Hash.new
ERRORS[:update] ||= Hash.new

# === UPDATE ===
ERRORS[:update].merge!({
  id_column_required:         t('commands.update.errors.id_column_required'),
  unenable_to_update_value:   t('commands.update.errors.unenable_to_update_value')
})
# === BUILD ===
ERRORS[:build].merge!({
  thing_required:       t('commands.build.errors.thing_required'),
  invalid_thing:        t('commands.build.errors.invalid_thing'),
})

NOTICES.key?(:build) || NOTICES.merge!(build: Hash.new)
NOTICES[:build].merge!(
  config_file_success: t('commands.build.notices.config_file_success')
)

class Project
class << self
  # Retourne la liste humaine des choses constructible avec la
  # commande build
  def buildable_things_hlist
    @buildable_things_hlist ||= BUILDABLE_THINGS.collect{|t,d| t.to_s}.pretty_join
  end

  def raise_thing_required
    raise(ERRORS[:build][:thing_required])
  end

  def raise_invalid_thing(thing)
    raise(ERRORS[:build][:invalid_thing] % [thing, buildable_things_hlist])
  end

end #<< self
end #/Project
end#/Scrivener
