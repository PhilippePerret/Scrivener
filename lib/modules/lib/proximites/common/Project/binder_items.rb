=begin
  Module de méthodes d'instance utilitaires pour les proximités

  Pour la requérir :

  Scrivener.require_module('lib_proximites')

=end
class Scrivener
  class Project

    MSGS = {
      no_document: 'Aucun document dont le nom est ou commence par « %s » n’a été trouvé parmi les documents :'
    }

    # Liste des binder_items qui gèrent les proximités, c'est-à-dire
    # le binder_item avant (s'il existe), le binder-item travaillé et le
    # binder-item suivant (s'il existe).
    # En général, on met dans cette propriété la valeur retournée par
    # `get_binder_items_around` (cf. ci-dessous)
    attr_accessor :watched_binder_items
    # Titre du document spécifiquement surveillé. Il peut être défini en
    # appelant la méthode `get_binder_items_around("<début de titre>")`
    attr_accessor :watched_document_title
    # Le binder-item concerné
    attr_accessor :watched_binder_item


    # Retourne tous les binder-items textuels du manuscrit du projet
    # Notez :
    #   - "textuel" — ce sont seulement les textes qui sont concernés
    #   - "manuscrit" — c'est seulement dans le dossier Manuscrit que sont
    #     cherchés le binder-items
    def all_binders
      @all_binders ||= all_binder_items_of(xfile.draftfolder, only_text: true)
    end

    # Le titre de tous les documents du projet spécifié (dans le manuscrit)
    def all_titles
      @all_titles ||= begin
        all_binders.collect { |bitem| bitem.title }
      end
    end


    # Retourne la liste de tous les binder-items qu'il faut considérer lorsque
    # l'on veut étudier le document de titre commençant par +titre_partiel+
    #
    # La méthode redéfinit aussi self.watched_document_title, le titre du
    # document surveillé.
    #
    def get_binder_items_around(titre_partiel)
      CLI.dbg("-> Scrivener::Project#get_binder_items_around (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
      arr_binder_items = Array.new # à la place de self.watched_binder_items = Array.new
      @all_titles = Array.new
      # On doit d'abord trouver le binder-item courant
      self.watched_binder_item  = nil
      this_binder_index = nil
      # Pour suivre l'offset courant de chaque binder-item
      cur_binder_offset = 0
      # On boucle dans les binder-items du projet jusqu'à trouver
      # le bon.
      all_binders.each_with_index do |bitem, index_bitem|
        # puts "-- title: #{bitem.title}"
        # On conserve tous les titres, dans le cas par exemple où il faudrait
        # les proposer à l'utilisateur.
        @all_titles << bitem.title
        # On profite de cette boucle pour récupérer tous les offsets start
        # des binder-items, afin de pouvoir calculer l'offset relatif des
        # mots en proximité.
        bitem.offset_start = cur_binder_offset

        # On en profite pour définir l'offset start de chaque binder-item
        self.binder_item(bitem.uuid).offset_start = cur_binder_offset
        # On définit le prochain offset
        cur_binder_offset += (bitem.texte||'').length

        if bitem.title.start_with?(titre_partiel)
          # On l'a trouvé !
          # On modifie le titre du document surveillé
          self.watched_document_title   = bitem.title
          self.watched_binder_item      = bitem
          self.watched_binder_item_uuid = bitem.uuid
          this_binder_index = index_bitem
          # break # non, on poursuit pour récupérer tous les titres
        end
      end

      # Si le binder-item n'a pas été trouvé, on lève une
      # exception
      self.watched_binder_item || raise_unfound_binder_item(MSGS[:no_document] % [watched_document_title])

      # Sinon, on poursuit
      #
      # On doit prendre les binders avant pour obtenir le bon nombre
      # de caractères à comparer

      if this_binder_index > 0
        len_before = 0
        all_binders[0...this_binder_index].reverse.each do |bitem|
          arr_binder_items << bitem
          len_before += (bitem.texte||'').length
          len_before < Proximite::DISTANCE_MINIMALE || break
        end
      end

      # Il faut retourner la liste des binder-items pour qu'ils soient
      # dans le bon ordre
      arr_binder_items.reverse!

      # On prend le binder-item surveillé et ceux après
      # jusqu'à une distance de surveillance adéquate
      len_after = 0
      all_binders[this_binder_index..-1].each_with_index do |bitem, bitem_index|
        arr_binder_items << bitem
        bitem_index > 0 || next
        len_after += bitem.texte.length
        len_after < Proximite::DISTANCE_MINIMALE || break
      end

      CLI.dbg("<- Scrivener::Project#get_binder_items_around (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
      return arr_binder_items
    end
    # /get_binder_items_around


    # ---------------------------------------------------------------------
    #   GESTION DES ERREURS


    def raise_unfound_binder_item msg
      msg = [msg.rouge]
      all_titles.each do |tit|
        msg << '  - %s' % tit
      end
      msg << 'Rappel : vous pouvez indiquer seulement le début du titre du document.'
      raise msg.join(String::RC)
    end
    # /raise_unfound_binder_item

  end #/Project
end #/Scrivener
