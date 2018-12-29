# encoding: UTF-8
=begin
  Module pour la commande 'build'
=end
class Scrivener
class Project
THINGS = {
documents:  {hname: 'documents'},
tdm:        {hname: 'table des matières'}
}
class << self

  attr_accessor :thing
  # Si true, on ne fait que simuler l'opération (comme la création des
  # documents par exemple)
  attr_accessor :simulation

  def exec_build thing = nil
    thing ||= CLI.params[1]
    thing             || raise_thing_required
    self.thing = thing.strip.downcase.to_sym
    is_thing?(self.thing)  || raise_invalid_thing
    self.simulation = !!CLI.options[:simulate]
    Project.include Object.const_get('Build%sModule' % thing.to_s.titleize)
    project.exec_building
  end

  # Return true si +thing+ est une chose constructible
  def is_thing?(thing)
    THINGS.key?(thing)
  end

end #/<< self
end #/Project
end #/Scrivener
