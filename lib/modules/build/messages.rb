# encoding: UTF-8
class Scrivener
ERRORS.merge!({
  build: {
    thing_required: 'Il faut définir la chose à construire en deuxième argument. P.e. `scriv build documents ...`',
    invalid_thing:  '"%s" est une chose à construire invalide (choisir parmi %s).'
  }
  })
class Project
class << self
  # Retourne la liste humaine des choses constructible avec la
  # commande build
  def buildable_things_hlist
    @buildable_things_hlist ||= THINGS.collect{|t,d| t.to_s}.pretty_join
  end

  def raise_thing_required
    raise(ERRORS[:build][:thing_required])
  end
  private :raise_thing_required
  def raise_invalid_thing
    raise(ERRORS[:build][:invalid_thing] % [thing, buildable_things_hlist])
  end
  private :raise_invalid_thing

end #<< self
end #/Project
end#/Scrivener
