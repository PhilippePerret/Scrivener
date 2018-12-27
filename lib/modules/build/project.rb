# encoding: UTF-8
=begin
  Module pour la commande 'build'
=end
class Scrivener
class Project
  
class << self

  def exec_build
    CLI.params[1] || raise(ERRORS[:build][:thing_required])
  end

end #/<< self
end #/Project
end #/Scrivener
