=begin

  Extension de CLI pour gérer les todo listes

=end
class CLI
class Todo

  MSGS = {
    unknown_task:     'Impossible de trouver la tâche désignée par %s.',
    confirm_save:     'Tâche enregistrée avec succès.',
    confirm_destroy:  'Tâche supprimée avec succès.',
    moveup_unenable:  'Impossible de remonter la tâche "%s".',
    ask_for_destroy:  'Voulez-vous supprimer la tâche "%s" ?'
  }

class << self

  # = main =
  #
  # Fonction principale gérant la commande `todo` de l'application courante.
  # On l'appelle avec `<application> todo[ <paramètres>]`
  def run
    if CLI.options[:help]
      puts help
    elsif operateur.nil? || operateur == 'list'
      display_list
    else
      index_task = indice_task(valeur)
      case operateur
      when '+'          then add_new_task(valeur)
      when '-'          then remove_task(index_task)
      when 'top'        then move_top_task(index_task)
      when 'bottom'     then move_bottom_task(index_task)
      when 'up'         then move_up_task(index_task)
      when 'down'       then move_down_task(index_task)
      when 'before'     then move_before_task(index_task, autre_valeur)
      when 'after'      then move_after_task(index_task, autre_valeur)
      else
        # En dernier recours, on affiche les choses à faire
        display_list
      end
    end
  rescue Exception => e
    puts e.message.rouge
    if CLI.verbose?
      puts e.backtrace[0..3].join(String::RC)
    end
  end

  # ---------------------------------------------------------------------
  # Opérations

  def add_new_task(task)
    tasks << task
    save
    puts MSGS[:confirm_save].bleu
  end


  # Déplacer la tâche vers le haut
  def move_up_task(tindex)
    tindex > 0 || raise(MSGS[:moveup_unenable] % task(tindex))
    ta = tasks.delete_at(tindex)
    tasks.insert(tindex - 1, ta)
    save and display_list
  end

  # Déplacer la tâche tout en haut
  def move_top_task(tindex)
    ta = tasks.delete_at(tindex)
    tasks.insert(0, ta)
    save and display_list
  end
  # Déplacer la tâche tout en bas
  def move_bottom_task(tindex)
    ta = tasks.delete_at(tindex)
    tasks.insert(-1, ta)
    save and display_list
  end
  # Déplacer la tâche vers le bas
  def move_down_task(tindex)
    tindex < tasks.count - 1 || raise(MSGS[:movedown_unenable] % task(tindex))
    ta = tasks.delete_at(tindex)
    tasks.insert(tindex + 1, ta)
    save and display_list
  end

  def move_before_task(tindex, after_ref)
    tindex_after = indice_task(after_ref) || raise(MSGS(:unknown_task) % after_ref.inspect)
    move_task(tindex, tindex_after)
  end
  def move_after_task(tindex, before_ref)
    tindex_before = indice_task(before_ref) || raise(MSGS(:unknown_task) % before_ref.inspect)
    move_task(tindex, tindex_before + 1)
  end
  def move_task(tindex, insertion_index)
    ta = task(tindex)
    tasks[tindex] = nil
    puts "--- tasks: #{tasks.inspect}"
    tasks.insert(insertion_index, ta)
    puts "--- tasks: #{tasks.inspect}"
    @tasks = tasks.compact
    save and display_list
  end

  def remove_task(index_task)
    index_task || raise(MSGS[:unknown_task] % index_task.inspect)
    confirm_destroy_task?(task(index_task)) || return
    tasks.delete_at(index_task)
    save
    puts MSGS[:confirm_destroy].bleu
  end
  # /remove_task


  def confirm_destroy_task?(task)
    yesOrNo(MSGS[:ask_for_destroy] % task)
  end

  # Enregistre les tâches
  def save
    File.unlink(todolist_path) if File.exist?(todolist_path)
    File.open(todolist_path,'wb'){|f| f.write tasks.join(String::RC)}
  end

  # ---------------------------------------------------------------------
  # Méthodes utilitaires

  # Retourne l'indice de la tâche ({Fixnum}) de référence +ref_task+
  # +ref_task+ peut être :
  #   - l'indice de la tâche (String)
  #   - la tâche complète
  #   - le début de la tâche.
  # Retourne NIL si la tâche n'existe pas
  def indice_task ref_task
    if ref_task.to_i.to_s == ref_task
      return ref_task.to_i - 1
    else
      tasks.each_with_index do |ta, ita|
        if ta.start_with?(ref_task)
          return ita
        end
      end
    end
    return nil
  end

  # ---------------------------------------------------------------------
  # Données

  # retourne la tâche d'indice +index+
  def task index
    tasks[index]
  end

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

  def autre_valeur
    @autre_valeur ||= CLI.params[3]
  end

  TAB_TODO_LIST = '   '
  def display_list
    if File.exist?(todolist_path)
      puts formated_tasks
    else
      puts "Pas de todo-list pour l'application `#{CLI.app_name}` pour le moment.\nPour créer votre première tâche, utilisez :\n`#{CLI.app_name} todo + \"<La tâche à accomplir>.\"`".bleu
    end
  end
  # /display_list

  # ---------------------------------------------------------------------
  #   HELPERS

  def formated_tasks
    @formated_tasks ||= begin
      indice_len = tasks.count.to_s.length
      ft = Array.new
      ft << String::RC * 2
      titre = "TODO-LIST DE L’APPLICATION `#{CLI.app_name}`"
      ft << TAB_TODO_LIST + titre + String::RC + TAB_TODO_LIST + '-'*titre.length
      tasks.each_with_index{|ta, ita| ft << '%s#%s : %s' % [TAB_TODO_LIST, (ita+1).to_s.ljust(indice_len), ta] }
      ft << String::RC * 2
      ft.join(String::RC)
    end
  end
  # ---------------------------------------------------------------------
  #   PATH
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

  #{'<app> todo[ list]'.jaune}

      Liste des choses à faire.

  #{'<app> todo + "Nouvelle tâche"'.jaune}

      Pour ajouter une nouvelle tâche.

  #{'<app> todo - "Début de la tâche"'.jaune}

      Pour supprimer une tâche par le début de son texte.

  #{'<app> todo - 6'.jaune}

      Pour supprimer une tâche par son numéro (le numéro qui
      est affiché quand on demande la liste des tâches).

  #{'<app> todo up|down "Début de la tâche"'.jaune}

      Pour remonter (up) ou descendre (down) une tâche désignée
      par le début de son texte.

  #{'<app> todo up|down 4'.jaune}

      Pour remonter (up) ou descendre (down) une tâche désignée
      par son numéro dans la liste.

  #{'<app> todo top|bottom "Début de la tâche"'.jaune}

      Pour mettre en haut (top) ou mettre en bas (bottom) une
      tâche désignée par le début de son texte.

  #{'<app> todo top|bottom 4'.jaune}

      Pour mettre en haut (top) ou mettre en bas (bottom) une
      tâche désignée par son numéro dans la liste.

  #{'<app> todo after|before "Début de la tâche" "Autre tâche"'.jaune}

      Pour placer la tâche désignée par son début de texte
      après (after) ou avant (before) la tâche désignée par
      le début de son texte.

  #{'<app> todo after|before 5 "Autre tâche"'.jaune}

      Pour placer la tâche désignée par son numéro dans la
      liste après (after) ou avant (before) la tâche désignée
      par le début de son texte (ou son numéro dans la liste).


    EOT
  end

end #/<< self
end #/Todo
end #/CLI
