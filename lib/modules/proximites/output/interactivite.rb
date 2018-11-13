=begin

  Tout ce qui concerne l'interactivité du programme

=end
class Scrivener
class Project
class Console
class << self

  def attendre_decision_user_et_traiter(win, iprox)
    case wait_for_commande(win)
    when 'c'
      iprox.cli_correction_proximite(self)
      # TODO Normalement, on ne peut pas rester sur la même proximité, qui
      # a disparu
    when 'j'
      # On revient à la proximité précédente, sauf si on est sur la
      # première, dans lequel cas il faut revenir au mot précédent et sa
      # dernière proximité
      if POINTEURS[:prox] > 0
        # <= L'index n'est pas le premier
        # => On peut prendre la proximité précédente
        POINTEURS[:prox] -= 1
      elsif POINTEURS[:mot] > 0
        # <= C'est la première proximité du mot courant, mais il y a des
        #    mots avant.
        # => On peut remonter au mot précédent
        unless cherche_mot_precedent_avec_proximites(start_at_fin = true)
          msg('C’est la toute première proximité. Il n’y en a pas avant.', :warning)
        end
      end
    when 'p'
      # On doit revenir au mot précédent
      reset_pointeurs_pour_mot_at(POINTEURS[:mot] - 1)
    when 'l', 'n'
      # On doit passer au mot suivant
      reset_pointeurs_pour_mot_at(POINTEURS[:mot] + 1)
    when 'q'
      return false
    when 'x'
      # Supprimer correction courant
      #
      if confirmation?('Confirmer la suppression de la proximité courante en jouant ENTRÉE')
        iprox.fix(ignore: true)
        msg('Cette proximité sera ignorée.', :info)
        reset_pointeurs_pour_mot_at(POINTEURS[:mot] + 1)
      end
    when 'X'
      # Supprimer tout le mot
      if confirmation?('Confirmer la suppression de TOUTES les occurences du mot courant en jouant ENTRÉE')
        msg('TODO: Implémenter la procédure de suppression de tout un mot', :info)
      end
    else
      # Dans tous les autres cas, on passe à la proximité suivante
      # Si l'indice est supérieur au nombre de proximité du mot
      # courant (dans POINTEURS), on passe au mot suivant :

      if POINTEURS[:prox] + 1 < POINTEURS[:nombre_proximites_mot]
        # => On peut passer à la proximité suivante pour le mot courant
        POINTEURS[:prox] += 1
      else
        # => On doit passer au mot suivant
        unless cherche_mot_suivant_avec_proximites
          if confirmation?('Reprendre au début ?', ['o', 'y'], ['o','y', 'n'])
            pointe_premier_mot_avec_proximites
          else
            return false # s'arrêter là
          end
        end
      end
    end
    return true
  end

  # @param msg  String  Le message (question) envoyé
  # @param expected_key String|Array  La touche ou les touches pour confirmer
  # @param only_keys    Array         Les seules touches autorisées.
  def confirmation? msg, expected_key = nil, only_keys = nil
    expected_key ||= ['o', 'y', 10] # touche entrée par défaut
    expected_key.is_a?(Array) || expected_key = [expected_key]
    if only_keys
      msg << " (#{only_keys.join('/')})"
    end
    begin
      msg(msg, :action)
      k = wait_for_commande
      if only_keys.nil? || only_keys.include?(k)
        break
      end
    end while true
    return expected_key.include?(k)
  end

  def wait_for_commande(win = nil)
    win ||= Curses.default_message_window
    win.respond_to?(:cwindow) && win = win.cwindow
    if CLI.mode_interactif?
      while
        choix = win.getch
        clear_msg
        case choix
        when "\e"
          # Ne rien faire
        else
          # msg('Touche : %s (%i)' % [choix, choix.ord], sleep: 2)
          return choix
        end
      end#/while
    else
      CLI.next_key_mode_test
    end
  rescue

  end

end #/<< self
end #/Console
end #/Project
end #/Scrivener
