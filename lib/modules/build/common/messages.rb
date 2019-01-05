# encoding: UTF-8
class Scrivener
ERRORS[:build]  ||= Hash.new
ERRORS[:update] ||= Hash.new

# === UPDATE ===
ERRORS[:update].merge!({
  id_column_required:         'Pour actualiser un projet, il faut impérativement une colonne d’identifiant (ID) pour retrouver les éléments.',
  unenable_to_update_value:   'Impossible d’actualiser la donnée de type "%s"'
})
# === BUILD ===
ERRORS[:build].merge!({
  # Général
  thing_required:       'Une chose à construire est requise (après `scriv build`)',
  invalid_thing:        'Jusqu’à preuve du contraire, la chose "%s" n’est pas constructible.',
})
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
