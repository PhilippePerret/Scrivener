=begin
  Module de méthodes d'instance utilitaires pour les proximités

  Pour la requérir :

  Scrivener.require_module('lib_proximites')

=end
class Scrivener
class Project

  # Crée les fichiers texte simple pour chaque binder-item de la
  # liste Array +bitems+
  # RETURN la liste des paths obtenues, qui pourra par exemple être envoyée
  # à l'analyse.
  def create_binder_items_text_files bitems
    bitems.collect do |bitem|
      bitem.build_simple_text_file
      bitem.simple_text_path
    end
  end

  # Liste des binder_items qui gèrent les proximités, c'est-à-dire
  # le binder_item avant (s'il existe), le binder-item travaillé et le
  # binder-item suivant (s'il existe).
  # En général, on met dans cette propriété la valeur retournée par
  # `get_binder_items_around` (cf. ci-dessous)
  attr_accessor :watched_binder_items
  attr_accessor :watched_binder_item_uuid
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

  # Met la liste des binder-items à surveiller dans self.watched_binder_items
  #
  # La méthode redéfinit aussi self.watched_document_title, le titre du
  # document surveillé.
  #
  def get_binder_items_around(titre_partiel)
    CLI.debug_entry
    arr_bitems  = Array.new # sera mis dans `self.watched_binder_items`
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
    self.watched_binder_item || raise_unfound_binder_item(t('documents.errors.no_document_with_heading', {heading_name: watched_document_title}, ArgumentError))

    # Sinon, on poursuit
    #
    # On doit prendre les binders avant pour obtenir le bon nombre
    # de caractères à comparer

    if this_binder_index > 0
      len_before = 0
      all_binders[0...this_binder_index].reverse.each do |bitem|
        arr_bitems << bitem
        len_before += (bitem.texte||'').length
        len_before < TextAnalyzer::DISTANCE_MINIMALE || break
      end
    end

    # Il faut retourner la liste des binder-items pour qu'ils soient
    # dans le bon ordre
    arr_bitems.reverse!

    # On prend le binder-item surveillé et ceux après
    # jusqu'à une distance de surveillance adéquate
    len_after = 0
    all_binders[this_binder_index..-1].each_with_index do |bitem, bitem_index|
      arr_bitems << bitem
      bitem_index > 0 || next
      len_after += bitem.texte.length
      len_after < TextAnalyzer::DISTANCE_MINIMALE || break
    end

    self.watched_binder_items = arr_bitems
    CLI.debug_exit
  end
  # /get_binder_items_around


  # ---------------------------------------------------------------------
  #   GESTION DES ERREURS


  def raise_unfound_binder_item msg
    msg = [msg.rouge]
    all_titles.each do |tit|
      msg << INDENT+('- %s' % tit)
    end
    msg << t('documents.notices.may_be_only_leading_doctitle')
    raise msg.join(String::RC)
  end
  # /raise_unfound_binder_item

end #/Project
end #/Scrivener
