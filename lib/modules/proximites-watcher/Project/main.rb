class Scrivener
  class Project

    attr_accessor :last_document_mtime

    # Liste des (jusqu'à 3) binder_items qui gèrent les proximités, c'est-à-dire
    # le binder_item avant (s'il existe), le binder-item travaillé et le
    # binder-item suivant (s'il existe)
    attr_accessor :watched_binder_items

    # Le titre (complet) du document actuellement surveillé
    attr_accessor :watched_document_title

    # = main =
    #
    # Lancement de la surveillance des proximités
    #
    def exec_watch_proximites
      options_conformes
      prepare_surveillance
      exec_boucle_surveillance
    rescue Exception => e
      raise_by_mode(e, Scrivener.mode)
    end
    # /exec_watch_proximites

    # Dans un premier temps on doit s'assurer que les options sont conformes
    # Ici, il faut avoir un document.
    def options_conformes
      self.watched_document_title = CLI.options[:document]
      # Le document doit avoir été précisé dans les options
      watched_document_title || begin
        raise 'Il faut indiquer le nom (ou le début du nom du document) à l’aide de l’option `-doc/--document="<nom>"`.'
      end
      # Le document précisé dans les options (partiellement ou entièrement)
      # doit vraiment exister
      # Cela consiste à rechercher en même temps les trois binder-items qui
      # devront être considérés.
      definir_trois_binder_items
    end
    # /options_conformes

    def prepare_surveillance
      Debug.init
      init_watch_proximites
    end

    def exec_boucle_surveillance
      fin = false
      begin
        # On attend une modification du fichier
        sleep 1 # voir si c'est pas mieux d'utiliser un thread
        # Quand le document a changé, il faut analyser l'état actuel et
        # le comparer à l'état précédent.
        if changement_has_occured?
          check_etat_proximites_et_affiche_differences
        end
      end while !fin
      # Note : mais en fait, c'est CTRL-C qui interrompt le programme.
    end
    # /exec_boucle_surveillance

    # Méthode qui définit les trois binder-items à prendre en compte
    # Noter que le titre du document a pu être donné partiellement
    def definir_trois_binder_items
      # puts "--> definir_trois_binder_items"
      self.watched_binder_items = Array.new
      # On boucle dans les binder-items du projet jusqu'à trouver
      # le bon.
      all_binders = all_binder_items_of(xfile.draftfolder, only_text: true)

      titles = Array.new
      all_binders.each_with_index do |bitem, index_bitem|
        # puts "-- title: #{bitem.title}"
        titles << bitem.title
        if bitem.title.start_with?(watched_document_title)
          # On a trouvé le document
          self.watched_document_title = bitem.title
          self.watched_binder_items << all_binders[index_bitem - 1]
          self.watched_binder_items << all_binders[index_bitem]
          self.watched_binder_items << all_binders[index_bitem + 1]
          self.watched_binder_items.compact!
          break
        end
      end

      if self.watched_binder_items.count < 1
        msg = ['Aucun document dont le nom est ou commence par « %s » n’a été trouvé parmi les documents :' % [watched_document_title]]
        titles.each do |tit|
          msg << '  - %s' % tit
        end
        msg << 'Rappel : vous pouvez indiquer seulement le début du titre du document.'
        raise msg.join(String::RC)
      end
    end

    # Retourne true si un changement est survenu dans les binder-item,
    # c'est-à-dire si leur mtime a changé depuis la dernière vérification
    def changement_has_occured?
      watched_binder_items.each do |bitem|
        if bitem.has_changed? then
          # Comme on va procéder à la vérification, on doit marquer la nouvelle
          # date pour les trois fichiers, pour ne pas faire trois fois
          # l'opération.
          watched_binder_items.each do |bitem|
            bitem.set_current_mtime
            # On en profite pour initialiser des valeurs importantes
            bitem.instance_variable_set('@texte', nil)
            # puts "--- Texte de #{bitem.uuid} : #{bitem.texte}"
          end
          return true
        end
      end
      return false
    end

  end #/Project
end #/Scrivener
