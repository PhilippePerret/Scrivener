# encoding: UTF-8

module BuildDocumentsModule
  class NewElement

    attr_accessor :projet
    attr_accessor :container
    attr_accessor :data_line, :args

    # +dline+ Les données contenues sur la ligne
    # +container+ Le conteneur du document (il en a toujours un, quel que
    #             soit sa profondeur)
    def initialize iprojet, container, dline, args = nil
      self.projet    = iprojet
      self.data_line = dline
      self.args      = args
      self.container = container
    end

    attr_accessor :titre
    attr_accessor :level
    # {BinderItem} Le bi résultant de la création de cet élément
    attr_accessor :binder_item

    # = main =
    #
    # Méthode principale qui traite l'élément courant
    def treate
      calc_titre_and_level
      if is_folder?
        self.container = projet.last_folder_by_level[self.level - 1]
      end

      # === CRÉATION DU BINDER-ITEM ===
      self.binder_item = container.create_binder_item(self.attrs_binder_item, self.data_binder_item)

      if is_folder?
        projet.last_folder_by_level.merge!(self.level => self.binder_item)
        projet.last_folder = self.binder_item
      end
    end
    # /treate

    def attrs_binder_item
      @attrs_binder_item ||= begin
        {
          type: is_document? ? 'Text' : 'Folder'
        }
      end
    end
    # Les données qui doivent permettre de créer le binder-item
    # (quel que soit son type, dossier ou document)
    def data_binder_item
      @data_binder_item ||= define_data_binder_item
    end

    def define_data_binder_item
      d = {
        title: self.titre,
        custom_metadatas: Hash.new
      }
      if self.target
        # TODO Certaines colonnes pour définir s'il faut afficher les dépassements
        d.merge!(text_settings: {target: {type: 'Characters', show_overrun: 'Yes', notify: 'No', value: self.target}})
      end
      # Si l'ID est défini
      self.id && d[:custom_metadatas].merge!(id: {value: self.id} )

      return d
    end

    # TODO : s'il y a une colonne "résumé"

    def target
      @target ||= begin
        projet.building_settings.target_column ? self.data_line[projet.building_settings.target_column].or_nil : nil
      end
    end

    def id
      @id ||= begin
        projet.building_settings.id_column ? self.data_line[projet.building_settings.id_column].or_nil : nil
      end
    end

    # On doit déterminer la profondeur de l'élément en fonction
    # de la profondeur du projet
    # Si la profondeur de la commande n'est pas définie ou est = 1,
    # la première colonne définit le titre
    def calc_titre_and_level
      if projet.building_settings.depth.nil?
        self.titre = data_line[0]
      else
        (0...projet.building_settings.depth).each do |icol|
          data_line[icol].strip != '' || next
          self.level = icol + 1
          break
        end
        self.titre = data_line[self.level - 1]
      end
    end

    # Retourne true si l'élément est un document
    def is_document?
      @self_is_a_document ||= self.level == projet.building_settings.depth
    end
    # Retourne true si l'élément est un dossier
    def is_folder?
      @self_is_a_folder ||= !is_document?
    end

  end #/Document

end #/module
