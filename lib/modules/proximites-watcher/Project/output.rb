require 'curses'
class Scrivener
  class Project

    # mis à true quand l'affichage dans Curses et préparé
    attr_accessor :display_inited

    # Les deux fenêtres Curses
    attr_accessor :winstate # Fenêtre affichant l'état (nombre proximités, etc.)
    attr_accessor :winlog   # Fenêtre des messages courants

    # = main =
    #
    # Méthode qui construit le tableau de l'état des proximités, les
    # message d'alerte (nouvelles proximités, proximités fixées) et autres
    # informations, et l'affiche dans une fenêtre Curses.
    def output_tableau_etat messages = nil
      CLI.dbg("-> Scrivener::Project#output_tableau_etat (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
      display_inited || init_display

      set_header_infos

      winlog.clear
      if messages
        messages.each do |str, style|
          write_log(str, style)
        end
      end
      winlog.cwindow.refresh

      CLI.dbg("<- Scrivener::Project#output_tableau_etat (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
    rescue Exception => e
      winstate  && winstate.close
      winlog    && winlog.close
      raise_by_mode(e, Scrivener.mode)
    end

    # Règle les infos supérieures (nombre de proxmités et liste de mots)
    def set_header_infos
      liste_mots = nil
      tbl = self.tableau_proximites
      if tbl
        nombre_proximites = tbl[:proximites].count
        if nombre_proximites > 0
          liste_mots = Hash.new
          tbl[:proximites].each do |prox_id, iprox|
            canon = iprox.mot_avant.canonique
            liste_mots.key?(canon) || liste_mots.merge!(canon => Array.new)
            liste_mots[canon] << iprox.distance
          end
          liste_mots = liste_mots.collect do |canon, distances|
            '"%s"%s' % [canon, " (#{distances.join(', ')})"]
          end.pretty_join
        end
      else
        nombre_proximites = '---'
      end
      write_state('Nombre de proximités : %s' % [nombre_proximites.to_s], liste_mots)
      # sleep 2
    end

    def write_state str, liste_mots = nil
      # winstate.affiche(str + String::RC, {line: 0, style: :bleu})
      winstate.affiche(' « ' + watched_document_title + ' » – ' + str, {style: :bleu, line: 0})
      # winstate.affiche(' ' + '–'*(Curses.cols - 4), {line: 2, style: :bleu})
      longueur_trait = Curses.cols - (watched_document_title.length + 12 + str.length)
      winstate.affiche(' ' + '–'*longueur_trait, {style: :bleu})
      if liste_mots
        winstate.affiche('     Mots trop proches : ' + liste_mots, {line: 1, style: :bleu})
      end
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
      CLI.dbg("-> Scrivener::Project#init_display (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
      # On prépare l'écran
      Curses.init # une de mes méthodes

      # Préparation des fenêtres
      nombre_lignes   = Curses.lines
      nombre_colonnes = Curses.cols

      debug("Nombre de lignes/colonnes dans l'écran : #{nombre_lignes}/#{nombre_colonnes}")

      sup_lines_state     = 9
      sup_lines_log       = 6
      top_window_state    = nombre_lignes - sup_lines_state
      top_window_log      = nombre_lignes - sup_lines_log
      nombre_lines_state  = sup_lines_state - sup_lines_log
      nombre_lines_log    = 6
      debug('* Instanciation des deux fenêtres…')
      self.winstate = Curses::Console::Window.new(nombre_lines_state, top: top_window_state)
      winstate.clear
      self.winlog   = Curses::Console::Window.new(nombre_lines_log, top: top_window_log)
      winlog.clear
      winlog.cwindow.setpos(0,0)
      debug('= Les deux fenêtres sont instanciées.')

      self.display_inited = true
      CLI.dbg("<--- Scrivener::Project#init_display (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
    rescue Exception => e
      if winlog
        winlog.cwindow.beep
      end
      raise_by_mode(e, Scrivener.mode)
    end

  end #/Project
end #/Scrivener
