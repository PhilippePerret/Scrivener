class Scrivener
  class Project

    attr_accessor :last_document_mtime

    # Liste des (jusqu'à 3) binder_items qui gèrent les proximités, c'est-à-dire
    # le binder_item avant (s'il existe), le binder-item travaillé et le
    # binder-item suivant (s'il existe)
    attr_accessor :watched_binder_items

    # Le titre (complet) du document actuellement surveillé
    attr_accessor :watched_document_title

    attr_accessor :tableau_proximites

    # = main =
    #
    # Lancement de la surveillance des proximités
    #
    def exec_watch_proximites
      Debug.init
      ask_for_ouverture
      prepare_surveillance
      options_conformes
      Proximite.init
      output_tableau_etat # pour le mettre en place
      check_etat_proximites_et_affiche_differences
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
        raise_exception_no_document('Il faut indiquer le nom (ou le début du nom du document) à l’aide de l’option `-doc/--document="<nom>"`.')
      end
      # Le document précisé dans les options (partiellement ou entièrement)
      # doit vraiment exister
      # Cela consiste à rechercher en même temps les trois binder-items qui
      # devront être considérés.
      get_binder_items_required
    end
    # /options_conformes

    def prepare_surveillance
      CLI.dbg("-> Scrivener::Project#prepare_surveillance (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
      init_watch_proximites
      CLI.dbg("<--- Scrivener::Project#prepare_surveillance (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
    end

    # Méthode qui définit les trois binder-items à prendre en compte
    # Noter que le titre du document a pu être donné partiellement
    def get_binder_items_required
      CLI.dbg("-> Scrivener::Project#get_binder_items_required (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
      self.watched_binder_items = Array.new


      @all_titles = Array.new

      # On doit d'abord trouver le binder-item courant
      this_binder_item  = nil
      this_binder_index = nil
      # On boucle dans les binder-items du projet jusqu'à trouver
      # le bon.
      all_binders.each_with_index do |bitem, index_bitem|
        # puts "-- title: #{bitem.title}"
        @all_titles << bitem.title
        if bitem.title.start_with?(watched_document_title)
          # On l'a trouvé !
          self.watched_document_title = bitem.title
          this_binder_item  = bitem
          this_binder_index = index_bitem
          # break # non, on poursuit pour récupérer tous les titres
        end
      end

      # Si le binder-item n'a pas été trouvé, on lève une
      # exception
      this_binder_item || begin
        raise_exception_no_document('Aucun document dont le nom est ou commence par « %s » n’a été trouvé parmi les documents :' % [watched_document_title])
      end

      # Sinon, on poursuit
      # On doit prendre les binders avant pour obtenir le bon nombre
      # de caractères à comparer

      if this_binder_index > 0
        len_before = 0
        all_binders[0...this_binder_index].reverse.each do |bitem|
          self.watched_binder_items << bitem
          len_before += bitem.texte.length
          len_before < Proximite::DISTANCE_MINIMALE || break
        end
      end

      # On prend le binder-item surveillé et ceux après
      # jusqu'à une distance de surveillance adéquate
      len_after = 0
      all_binders[this_binder_index..-1].each_with_index do |bitem, bitem_index|
        self.watched_binder_items << bitem
        bitem_index > 0 || next
        len_after += bitem.texte.length
        len_after < Proximite::DISTANCE_MINIMALE || break
      end

      debug('Binder-item surveillé : « %s »' % watched_document_title)
      debug("Binder-items retenus : #{self.watched_binder_items.collect{|bi|bi.title}}")
      CLI.dbg("<--- Scrivener::Project#get_binder_items_required (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
    end
    # /get_binder_items_required

    def raise_exception_no_document msg
      msg = [msg]
      all_titles.each do |tit|
        msg << '  - %s' % tit
      end
      msg << 'Rappel : vous pouvez indiquer seulement le début du titre du document.'
      raise msg.join(String::RC)
    end
    # /raise_exception_no_document

    # Retourne tous les binder-items textuels du manuscrit du projet
    def all_binders
      @all_binders ||= all_binder_items_of(xfile.draftfolder, only_text: true)
    end

    # Le titre de tous les documents du projet spécifié (dans le manuscrit)
    def all_titles
      @all_titles ||= begin
        all_binders.collect { |bitem| bitem.title }
      end
    end

  end #/Project
end #/Scrivener
