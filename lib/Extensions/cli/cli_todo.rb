=begin

  Extension de CLI pour gérer les todo listes

=end
class CLI
class Todo
class << self

  # = main =
  #
  # Fonction principale gérant la commande `todo` de l'application courante.
  # On l'appelle avec `<application> todo[ <paramètres>]`
  def run
    if CLI.options[:help]
      puts help
    elsif operateur == '+'
      add_new_task(valeur)
    elsif operateur == '-'
      remove_task(valeur)
    else
      # En dernier recours, on affiche les choses à faire
      display_todo_list
    end
  end

  # ---------------------------------------------------------------------
  # Opérations

  def add_new_task(task)
    tasks << task
    save
    puts "Tâche enregistrée avec succès.".bleu
  end

  def remove_task(debut_task)
    index_task_to_remove = nil
    tasks.each_with_index do |ta, ita|
      if ta.start_with?(debut_task)
        if yesOrNo('Voulez-vous supprimer la tâche "%s" ?' % ta)
          index_task_to_remove = ita
          break
        end
      end
    end
    if index_task_to_remove
      tasks.delete_at(index_task_to_remove)
      save
      puts "Tâche supprimée avec succès.".bleu
    else
      puts "Impossible de trouver la tâche voulue.".rouge
    end
  end

  # Enregistre les tâches
  def save
    File.unlink(todolist_path) if File.exist?(todolist_path)
    File.open(todolist_path,'wb'){|f| f.write tasks.join(String::RC)}
  end

  # ---------------------------------------------------------------------
  # Données

  # Liste des tâches
  def tasks
    @tasks ||= begin
      if File.exist?(todolist_path)
        File.read(todolist_path).split(String::RC)
      else
        Array.new
      end
    end
  end
  def operateur
    @operateur ||= CLI.params[1]
  end

  def valeur
    @valeur ||= CLI.params[2]
  end

  def display_todo_list
    if File.exist?(todolist_path)
      puts String::RC * 3
      puts <<-EOT
TODO-LIST DE L’APPLICATION #{CLI.app_name}
-----------------------------------------------
#{File.read(todolist_path)}
      EOT
      puts String::RC * 3
    else
      puts "Pas de todo-list pour l'application `#{CLI.app_name}` pour le moment.\nPour créer votre première tâche, utilisez :\n`#{CLI.app_name} todo + \"<La tâche à accomplir>.\"`".bleu
    end
  end
  # /display_todo_list

  def todolist_path
    @todolist_path ||= File.join(cli_todo_folder,CLI.app_name)
  end

  def cli_todo_folder
    @cli_todo_folder ||= begin
      d = File.join(CLI.cli_home_folder,'todo')
      `mkdir -p "#{d}"`
      d
    end
  end


  def help
    <<-EOT

AIDE DE LA COMMANDE `todo`
--------------------------

Note : on peut trouver une aide plus détaillée dans le manuel de la
commande CLI.

  #{'<app> todo -h/--help'.jaune}

      Obtenir cette aide.

  #{'<app> todo'.jaune}

      Liste des choses à faire.

    EOT
  end

end #/<< self
end #/Todo
end #/CLI
