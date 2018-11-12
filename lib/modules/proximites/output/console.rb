=begin
  Pour sortir le résultat en console
=end
require 'curses'

class Scrivener
class Project
class Console

  CONSOLE_WIDTH = 70

  SEPARATEURS = {
    guils: nil,
    }

class << self

  attr_accessor :tableau

  # Raccourci pour écrire des messages à l'écran (en bas)
  def msg str, options = nil
    Curses::MessageWindow.message(str, options)
  end
  def clear_msg
    Curses::MessageWindow.message('')
  end

  def output(tableau)
    CLI.dbg("-> Scrivener::Project::Console#output (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")

    self.tableau = tableau

    # On prépare l'écran
    Curses.init_screen
    Curses.curs_set(0)  # Curseur invisible
    Curses.start_color
    Curses.noecho

    SEPARATEURS[:guils] = '"'*(Curses.cols - 4)
    SEPARATEURS[:plats] = '–'*(Curses.cols - 4)

    # Initialisation des couleurs customisées
    Curses.init_custom_color # méthode propre à l'extension

    # On prépare les deux parties d'écran

    nombre_lines_windown    = 6
    nombre_lines_winheader  = 3
    nombre_lines_winup      = Curses.lines - (nombre_lines_winheader + nombre_lines_windown + 1)
    top_windown = nombre_lines_winheader + nombre_lines_winup
    # Note : le "+1" de la fin sert à la fenêtre des messages


    # --- Les fenêtres ---
    winheader = Window.new(nombre_lines_winheader, background: Curses::CUSTOM_COLORS[:noir_sur_blanc])
    winup     = Window.new(nombre_lines_winup, top: nombre_lines_winheader, background: Curses::CUSTOM_COLORS[:noir_sur_blanc])
    windown   = Window.new(nombre_lines_windown, top: top_windown)

    Curses.default_message_window = windown.cwindow #méthode propre à l'extension

    begin
      Curses::MessageWindow.create(top: Curses.lines - 1)
      # On prépare les fenêtres
      windown.affiche(panneau_nomenclature)

      # On prépare l'entête pour les données
      prepare_header_up_window(winheader)

    rescue Exception => e
      winup.affiche(e.message)
      winup.affiche(String::RC + e.backtrace.first)
      debug(e)
      sleep 4
    end



    liste_mots = tableau[:mots]

    poursuivre = true

    mots_canoniques = liste_mots.keys
    nombre_mots     = mots_canoniques.count
    pointeur_mot    = 0
    pointeur_prox   = nil

    # liste_mots.each do |mot_canonique, data_mot|
    while # tans qu'on ne procède pas à la fin

      mots_canoniques[pointeur_mot] || begin
        pointeur_mot = 0
        # Note: ruby râle si on met sur une ligne
      end
      mot_canonique = mots_canoniques[pointeur_mot]
      data_mot      = liste_mots[mot_canonique]

      # S'il n'y a pas de proximité avec le mot courant, on passe
      # au mot suivant
      data_mot[:proximites].empty? && begin
        pointeur_mot += 1
        # Si on arrive au bout de la liste, on s'arrête.
        # Sinon, on prend le mot suivant.
        if pointeur_mot == nombre_mots
          if confirmation?('Fin de la liste. Voulez-vous reprendre au début ?', ['o', 'y'], ['o', 'y', 'n'])
            pointeur_mot  = 0
            pointeur_prox = 0
          else
            break
          end
        else
          next
        end
      end

      nombre_proximites = data_mot[:proximites].count
      # Le pointeur pour parcourir toutes les proximités
      if pointeur_prox == -1
        pointeur_prox = nombre_proximites - 1
      else
        pointeur_prox = 0
      end


      while
        prox_id = data_mot[:proximites][pointeur_prox]
        prox_id || break # la dernière est atteinte

        # La proximité courante
        # TODO Vérifier que ce soit bon (depuis que je supprime des proximités
        # dans la liste)
        iprox = tableau[:proximites][prox_id]
        if iprox.nil? || iprox.erased?
          pointeur_prox += 1
          next
        end

        begin

          # ==== AFFICHAGE LIGNE D'ENTÊTE ====
          winheader.affiche(header_with_data(iprox, pointeur_prox + 1, nombre_proximites), line: 1, style: [:bleu, :gras])

          # On règle les décalages de départ et de fin du binder-item contenant
          # le/les mots
          [iprox.mot_avant, iprox.mot_apres].each do |imot|
            imot.binder_item.offset_start || imot.set_offsets_bitem(tableau[:binder_items])
          end

          # ==== AFFICHAGE DU BLOC DE PROXIMITÉ (extrait) =====
          winup.clear
          winup.sput(iprox.line_with_words_and_distance, style: :rouge)
          # winup.affiche(SEPARATEURS[:guils], line: indice_line)
          winup.sput(SEPARATEURS[:plats], style: :rouge)
          iprox.extrait.each_with_index do |data_line, index_extrait|
            winup.sput(data_line[0], data_line[1])
          end
          winup.sput(SEPARATEURS[:plats], style: :rouge)

        rescue Exception => e
          winup.affiche('%{rc}PROBLÈME : %{err_msg}%{rc}%{btrace}' %
            {rc: "\n", err_msg: e.message, btrace: e.backtrace[0..2].join("\n")})
          debug(e)
          sleep 4
        end


        # Demande sur la suite à faire
        # poursuivre, pointeur_mot, pointeur_prox
        prox_suivante, poursuivre, pointeur_mot, pointeur_prox =
          attendre_decision_user_et_traiter(windown, iprox, poursuivre, pointeur_mot, pointeur_prox)

        prox_suivante || break
        poursuivre    || break

      end

      poursuivre || break
      pointeur_mot += 1

    end
    # /fin de boucle sur tous les mots à proximité


    # Il faut voir s'il faut sauver
    # TODO : lorsqu'on pourra régler la sauvegarde automatique, on pourra
    # le faire sans demander
    if project.modified?
      if confirmation?('Le projet a été modifié. Dois-je le sauver ?', ['o','y'], ['o','y', 'n'])
        project.save_proximites
      end
    end

  rescue Exception => e
    winup.affiche(e.message)
    winup.affiche(String::RC + e.backtrace[0..1].join(String::RC))
    sleep 4
    debug(e)
  ensure
    winheader && winheader.close
    winup     && winup.close
    windown   && windown.close
    Curses.close_screen
  end
  # /output


end #/<< self
end #/Console
end #/Project
end #/Scriver
