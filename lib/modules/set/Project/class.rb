# encoding: UTF-8
class Scrivener
class Project
class << self

  # = main =
  #
  # Méthode principale pour exécuter la commande `set`
  def exec_set
    CLI.options[:help] && begin
      return project.help_command_set
    end
    puts NOTICES[:require_project_closed].bleu
    if CLI.options[:from]
      project.set_values_from_file
    else
      project.set_values
    end
    project.save_all
  end
  # /exec_set

end #/<< self
end #/Project
end #/Scrivener
