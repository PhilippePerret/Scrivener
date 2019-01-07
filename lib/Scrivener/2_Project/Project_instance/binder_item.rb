# encoding: UTF-8
=begin

  Méthodes utiles

    project.binder_item(<uuid>) retourne l'instance Scrivener::Project::BinderItem
    de n'importe quel binder du dossier manuscrit.

    project.binder_items
      retourne la liste des binder-items {Scrivener::Project::BinderItem} mais
      seulement de premier niveau (pas les sous-éléments, qu'il faudra traiter
      à l'aide de la méthode `parent?` et `children`).

=end
class Scrivener
class Project

  # Retourne l'instance {Scrivener::Project::BinderItem} du binder item du
  # projet portant l'UUID +uuid+
  # +uuid+ peut aussi avoir les valeurs :
  #   :draft_folder     Le dossier manuscrit
  #   :search_folder    Le dossier recherche
  #   :trash_folder     Le dossier poubelle
  #
  # Note : cette méthode (contrairement aux suivantes) considère vraiment
  # TOUS les binder-items, à commencer par le dossier manuscrit principal
  # (alors que `binder_items` ci-dessous ne recherche que les éléments du
  # dossier manuscrit, même pas le dossier manuscrit lui-même)
  def binder_item uuid
    @hash_binder_items ||= begin
      h = Hash.new
      xfile.binder.elements.each('BinderItem') do |data_node|
        bi = Scrivener::Project::BinderItem.new(self, data_node)
        # Traitement spécial des dossiers racines
        if ['DraftFolder','ResearchFolder','TrashFolder'].include?(data_node.attributes['Type'])
          h.merge!(data_node.attributes['Type'].decamelize.to_sym => bi)
        end
        bi.merge_in(h) # Traite aussi les enfants
      end
      h
    end
    @hash_binder_items[uuid]
  end
  alias :binder_item_by_uuid :binder_item

  # Retourne l'instance binder-item du fichier ou dossier dont le titre
  # est ou commence par +titseg+
  #
  # +options+
  #     :help       Si true (par défaut), on affiche la liste des titres
  #                 en cas d'insuccès. Noter qu'il faut mettre explicitement
  #                 :help à false pour qu'elle ne soit pas affichée. Sauf
  #                 si :raise est true, qui est prioritaire
  #     :in         Le dossier dans lequel il faut chercher le document
  #                 (par défaut : :draft_folder, le dossier manuscrit)
  #     :raise      Si true, on raise quand on ne trouve pas le document
  #
  def binder_item_by_title titseg, options = nil
    options ||= Hash.new
    options.key?(:in) || options.merge!(in: :draft_folder)
    titseg_init = titseg.to_s
    titseg = titseg.strip.downcase
    all_bitems = Array.new
    self.all_binder_items_of(options[:in]).each do |bitem|
      # puts "* Comparaison de %s et %s" % [titseg.inspect, bitem.title.downcase.inspect]
      if bitem.title.downcase.start_with?(titseg)
        return bitem
      end
      all_bitems << bitem
    end
    options[:raise] && raise(ArgumentError, ERRORS[:binder_item][:unfound_with_title] % titseg_init)
    options[:help] === false || ask_for_binder_item_in(all_bitems)
  end

  # Permet de retrouver un binder-item par son ID. Attention, il ne s'agit
  # pas de l'UUID du binder-item, mais d'une métadonnée ID définie par exemple
  # quand on construit le projet à partir d'un fichier CSV.
  #
  # Return l'instance BinderItem ou nil
  def binder_item_by_id bitem_id, options = nil
    options ||= Hash.new
    options.key?(:in) || options.merge!(in: :draft_folder)

    # self.all_binder_items_of(options[:in]).each do |bitem|
    # NON: ON DOIT ALLER PLUS VITE EN RECHERCHANT DIRECTEMENT
    # DANS LE FICHIER XFILE COMME CI-DESSOUS
    # end

    bitem_id = bitem_id.to_s
    bitem = nil
    REXML::XPath.each(xfile.root, '//BinderItem/MetaData/CustomMetaData/MetaDataItem/FieldID[text()="id"]') do |n|
      parent = n.parent
      bitem_id == parent.elements['Value'].text || next
      begin
        parent = parent.parent
      end until parent.name == 'BinderItem'
      bitem = parent
      break
    end
    bitem || return
    # Ici, bitem est un noeud
    return binder_item(bitem.attributes['UUID'])
  end
  # /binder_item_by_id

  # Affiche la liste des documents actuels du projet et demande
  # à l'utilisateur d'en choisir un.
  # Returne nil en cas d'annulation.
  def ask_for_binder_item_in(arr_bitems)
    puts "Merci de choisir un document dans la liste ci-dessous : ".rouge
    puts String::RC * 2
    puts "Liste des documents"
    puts "-------------------"
    allindex = Array.new
    arr_bitems.each_with_index do |bi, idx|
      num = (idx + 1).to_s
      allindex << num
      puts '  %s : %s' % [num.rjust(4), bi.title]
    end
    puts String::RC * 3
    choix = askFor('Document à choisir (ou "q" pour renoncer)', {expected_keys: allindex.push('q')})
    if choix == 'q'
      return nil
    else
      arr_bitems[choix.to_i - 1]
    end
  end

  # Retourne l'instance {Scrivener::Project::BinderItem} du
  # dossier Manuscrit
  def draft_folder
    @draft_folder ||= binder_item(:draft_folder)
  end
  # Retourne l'instance {Scrivener::Project::BinderItem} du
  # dossier Recherche (SearchFolder)
  def research_folder
    @research_folder ||= binder_item(:research_folder)
  end
  # Retourne l'instance {Scrivener::Project::BinderItem} du
  # dossier Poubelle
  def trash_folder
    @trash_folder ||= binder_item(:trash_folder)
  end

  # Retourne tous les binder-items du dossier +dossier+, avec les
  # options +options+
  #
  # +dossier+ Le noeud XML du dossier. On peut aussi utiliser les valeurs
  #           spéciales :draft_folder, :research_folder ou :trash_folder
  #
  # +options+
  #   :only_text    Seulement les textes
  #   :deep         Fouille les sous-dossier (true par défaut)
  #
  def all_binder_items_of dossier, options = nil
    options ||= Hash.new
    options.key?(:deep) || options.merge!(deep: true)
    dossier.is_a?(Symbol) && dossier = self.send(dossier).node
    arr = Array.new
    dossier.elements.each('Children/BinderItem') do |data_node|
      bitem = Scrivener::Project::BinderItem.new(self, data_node)
      add_binder_item_in(arr, bitem, options)
    end
    return arr
  end

  # Méthode qui ajoute les binder-items et ses enfants dans la liste +arr+
  # suivant les options +options+
  # +options+ Cf. ci-dessus.
  def add_binder_item_in arr, bitem, options
    unless options[:only_text] && !bitem.text?
      arr << bitem
    end
    (bitem.children && options[:deep]) || return
    bitem.children.each do |child|
      add_binder_item_in arr, child, options
    end
    return arr
  end

  # Pour composer la tableau @hash_binder_items du projet qui contient en
  # clé l'UUID du fichier et en valeur l'instance Scrivener::Project::BinderItem
  class BinderItem
    def merge_in h
      h.merge!(self.uuid => self)
      self.parent? && self.children.each{|bic| bic.merge_in(h)}
    end
  end #/BinderItem


  # Méthode principale qui crée un nouveau document pour le
  # projet. Avec éventuellement les données +data+
  #
  # RETURN Le nouveau binder-item créé {Scrivener::Project::BinderItem}
  def create_binder_item attrs = nil, data = nil
    data  ||= Hash.new

    # On doit définir le conteneur
    conteneur =
      case data[:container]
      when String
        container = data.delete(:container)
        # xfile.draftfolder.elements["*/BinderItem[@UUID=\"#{container}\"]"]
        xfile.node.elements["*/BinderItem[@UUID=\"#{container}\"]"]
      when Scrivener::Project::BinderItem
        raise 'Je ne sais pas traiter les BinderItems'
      else
        # Sinon, on prend le dossier manuscrit
        xfile.draftfolder
      end
    return conteneur.create_binder_item(attrs, data)
  end
  #/create_binder_item

end #/Project
end #/Scrivener
