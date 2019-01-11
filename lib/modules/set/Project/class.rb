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
    if Scrivener.command_on_project?
      wt('projects.notices.require_project_closed', nil, {color: :bleu})
      if CLI.options[:from]
        project.set_values_from_file
      else
        project.set_values
      end
      project.save_all
    else
      # Si ce n'est pas une commande sur projet
      # Rappel : pour les commandes qui ne se font pas sur projet (par
      # exemple `set lang` qui définit la langue de scriv, il faut
      # le définir dans la constante : NOT_ON_PROJECT_COMMANDS
      # du fichier ./lib/Scrivener/1_Scrivener/init.rb)
      Scrivener.set_values
    end
  end
  # /exec_set

end #/<< self
end #/Project
end #/Scrivener
