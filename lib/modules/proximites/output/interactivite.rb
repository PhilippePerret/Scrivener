=begin

  Tout ce qui concerne l'interactivité du programme

=end
class Scrivener
class Project
class Console
class << self

  def attendre_decision_user_et_traiter(windown, poursuivre, pointeur_mot, pointeur_prox)
    prox_suivante = true # par défaut
    case wait_for_commande(windown)
    when 'c'
      if confirmation?('Pour confirmer la correction, presser la touche ENTRÉE')
        msg('Il faut implémenter la correction', {type: :warning, sleep: 4})
      end
    when 'j'
      # On revient à la proximité précédente, sauf si on est sur la
      # première, dans lequel cas il faut revenir au mot précédent et sa
      # dernière proximité
      if pointeur_prox == 0
        if pointeur_mot > 0
          pointeur_mot -= 2   # pour revenir au mot précédent
          pointeur_prox = -1  # le dernier mot (sera calculé)
        else
          # On ne fait rien
        end
        prox_suivante = false
      else
        pointeur_prox -= 1
      end
    when 'p'
      # On doit revenir au mot précédent
      pointeur_mot -= 2
      prox_suivante = false
    when 'l', 'n'
      # On doit passer au mot suivant
      prox_suivante = false
    when 'q'
      poursuivre = false
    when 'x'
      # Supprimer correction courant
      #
      if confirmation?('Confirmer la suppression de la proximité courante en jouant ENTRÉE')
        msg('TODO: Implémenter la procédure de suppression de la proximité', :info)
      end
    when 'X'
      # Supprimer tout le mot
      if confirmation?('Confirmer la supprimer de TOUTES les occurences du mot courant en jouant ENTRÉE')
        msg('TODO: Implémenter la procédure de suppression de tout un mot', :info)
      end
    else
      # Dans tous les autres cas, on passe à la proximité suivante
      pointeur_prox += 1
    end
    return [prox_suivante, poursuivre, pointeur_mot, pointeur_prox]
  end

  def confirmation? msg, expected_key = nil
    expected_key ||= 10 # touche entrée par défaut
    msg(msg, :action)
    return wait_for_commande == expected_key
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
