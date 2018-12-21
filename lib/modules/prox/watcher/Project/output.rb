require 'curses'
class Scrivener
class Project

  # mis à true quand l'affichage dans Curses et préparé
  attr_accessor :display_inited

  # Les trois fenêtres Curses
  attr_accessor :winproxi # Fenêtre de l'ensemble des proximités
  attr_accessor :winstate # Fenêtre affichant l'état (nombre proximités, etc.)
  attr_accessor :winlog   # Fenêtre des messages courants

  # = main =
  #
  # Méthode qui construit le tableau de l'état des proximités, les
  # message d'alerte (nouvelles proximités, proximités fixées) et autres
  # informations, et l'affiche dans une fenêtre Curses.
  #
  # Constitution de la fenêtre :
  #
  #     ----------------------------------------------------------
  #     | Liste des proximités courantes
  #     | (winproxi)
  #     |
  #     |----------------------------------------------------------
  #     | Résumé des proximités (nombre)
  #     | (winstate)
  #     |---------------------------------------------------------
  #     | Dernières modifications (proximités corrigées ou
  #     | ajoutées). Géré par les Proximite::Table et Proximite::TableComparaison
  #     | (winlog)
  #     ------------------------------------------------------------
  #
  def output_tableau_etat
    CLI.debug_entry
    display_inited || init_display
    # Entête du bas (sic) avec notamment le nom du document et le nombre
    # de proximités courant.
    display_header_infos
    # Affichage, dans la partie supérieure, de toutes les proximités courantes
    display_proximites_courantes

  rescue Exception => e
    raise_by_mode(e, Scrivener.mode)
    winproxi  && winproxi.close
    winstate  && winstate.close
    winlog    && winlog.close
  ensure
    CLI.debug_exit
  end

  TEMP_PROX_AFF = '%{pmot} [%{offset} in « %{doc} »] <- %{dist_cars}|%{dist_mots} mots -> %{mark_nmot}'

  def compose_proxi_display_for iprox
    pmot = iprox.mot_avant.real
    nmot = iprox.mot_apres.real
    same_mot = nmot.downcase == pmot.downcase
    str = TEMP_PROX_AFF % {
      pmot:       pmot,
      mark_nmot:  same_mot ? 'id.' : nmot,
      offset:     iprox.mot_avant.relative_offset,
      doc:        iprox.mot_avant.binder_item.title,
      dist_cars:  iprox.distance,
      dist_mots:  iprox.distance / 6
    }
    return str.ljust(largeur_colonne_proxi)
  end
  # /compose_proxi_display_for

  # Affiche dans winproxi les proximités courantes. Elles sont réparties
  # dans trois colonnes.
  def display_proximites_courantes
    winproxi.clear

    # Pour construire l'affichage, on fonctionne en deux colonnes. On définit
    # l'élément gauche (left_prox) et l'élément droite (right_prox). S'ils ne
    # dépassent pas la largeur de l'écran (Curses.cols - 1), on les affiche
    # côte à côté. Sinon, on n'affiche que l'élément gauche et on garde
    # l'élément droite pour le tester avec la suite.
    iterator = 0
    right_proxi = nil # on peut reprendre le dernier
    all_proxs = self.analyse.table_resultats.proximites.values
    while iprox = all_proxs[iterator]

      # Soit il faut reprendre la proximité de droite pour la mettre à
      # gauche quand on n'a pas pu l'écrire sur la ligne, soit il faut en
      # prendre une nouvelle.
      left_proxi  = right_proxi || begin
        compose_proxi_display_for(iprox)
      end
      iterator += 1
      # Dans tous les cas on prend la proximité de droite
      right_proxi = compose_proxi_display_for(all_proxs[iterator])
      iterator += 1

      if left_proxi.length + right_proxi.length < Curses.cols
        line = left_proxi + right_proxi
        left_proxi = right_proxi = nil
      else
        line = left_proxi
        left_proxi = nil
      end
      winproxi.affiche(line + String::RC)
    end
    # /fin de boucle sur toutes les proximités

    # S'il reste à afficher la droite
    right_proxi && winproxi.affiche(right_proxi)

    winproxi.refresh
  rescue Exception => e
    raise_by_mode(e, Scrivener.mode)
  end
  # /display_proximites_courantes


  # Règle les infos supérieures (nombre de proxmités et liste de mots)
  def display_header_infos
    if self.analyse.table_resultats
      nombre_proximites = self.analyse.table_resultats.proximites.count
    else
      nombre_proximites = '---'
    end
    write_state('Nombre de proximités : %s' % [nombre_proximites.to_s])
  end
  # /display_header_infos

  def write_proxi str, style = nil
    data_proxi = Hash.new
    style && data_proxi.merge!(style: style)
    winproxi.affiche(str, data_proxi)
  end

  # Largeur d'une colonne dans la colonne proxi qui doit en comporter 4
  def largeur_colonne_proxi
    @largeur_colonne_proxi ||= (Curses.cols / 2) - 1
  end


  def write_state str
    # winstate.affiche(str + String::RC, {line: 0, style: :bleu})
    winstate.affiche(' « ' + watched_document_title + ' » – ' + str, {style: :bleu, line: 0})
    # winstate.affiche(' ' + '–'*(Curses.cols - 4), {line: 2, style: :bleu})
    longueur_trait = Curses.cols - (watched_document_title.length + 12 + str.length)
    winstate.affiche(' ' + '–'*longueur_trait, {style: :bleu})
  rescue Exception => e
    debug(e)
    raise_by_mode(e, Scrivener.mode)
  end

  def write_log str, style = nil, init = false
    wnd = winlog.cwindow
    if init
      wnd.clear
    end
    if style
      wnd.attron(Curses.disp_attributes(style)) do
        wnd.addstr('  ' + str + String::RC)
      end
    else
      wnd.addstr('  ' + str + String::RC)
    end
    wnd.refresh
  rescue Exception => e
    debug(e)
    raise_by_mode(e, Scrivener.mode)
  end

  # Initialiastion de l'affichage
  def init_display
    CLI.debug_entry
    # On prépare l'écran
    Curses.init # une de mes méthodes

    # Préparation des fenêtres
    nombre_lignes   = Curses.lines
    nombre_colonnes = Curses.cols

    debug("Nombre de lignes/colonnes dans l'écran : #{nombre_lignes}/#{nombre_colonnes}")

    sup_lines_state     = 9
    sup_lines_log       = 7
    top_window_state    = nombre_lignes - sup_lines_state
    top_window_log      = nombre_lignes - sup_lines_log
    nombre_lines_state  = sup_lines_state - sup_lines_log
    nombre_lines_log    = 7
    nombre_lines_proxi  = nombre_lignes - sup_lines_state - 1
    debug('* Instanciation des trois fenêtres…')
    self.winproxi = Curses::Console::Window.new(nombre_lines_proxi, top: 0)
    self.winstate = Curses::Console::Window.new(nombre_lines_state, top: top_window_state)
    winstate.clear
    self.winlog   = Curses::Console::Window.new(nombre_lines_log, top: top_window_log)
    winlog.clear
    winlog.cwindow.setpos(0,0)
    debug('= Les trois fenêtres ont été instanciées avec succès.')

    self.display_inited = true
    CLI.debug_exit
  rescue Exception => e
    if winlog
      winlog.cwindow.beep
    end
    raise_by_mode(e, Scrivener.mode)
  end

end #/Project
end #/Scrivener
