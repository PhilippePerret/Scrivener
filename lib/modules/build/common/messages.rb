# frozen_string_literal: true
# encoding: UTF-8
class Scrivener
class Project
class << self
  # Retourne la liste humaine des choses constructible avec la
  # commande build
  def buildable_things_hlist
    @buildable_things_hlist ||= BUILDABLE_THINGS.collect{|t,d| t.to_s}.pretty_join
  end

  def raise_thing_required
    rt('commands.build.errors.thing_required')
  end

end #<< self
end #/Project
end#/Scrivener
