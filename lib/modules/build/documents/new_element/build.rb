# encoding: UTF-8

module BuildDocumentsModule
  class NewElement

    # +dline+ Les données contenues sur la ligne
    # +container+ Le conteneur du document (il en a toujours un, quel que
    #             soit sa profondeur)
    def initialize iprojet, container, dline, args = nil
      self.projet    = iprojet
      self.data_line = dline
      self.args      = args
      self.container = container
      calc_titre_and_level
    end

    # = main =
    #
    # Méthode principale qui traite l'élément courant
    def build
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
    # /build

    def not_interactive?
      !CLI.options[:interactive]
    end

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
      # Si d'autres colonnes sont définies
      if projet.building_settings.metadatas_columns
        projet.building_settings.metadatas_columns.each do |col_idx, col_name|
          d[:custom_metadatas].merge!(col_name => {value: data_line[col_idx]})
        end
        # puts "-- custom metadatas à prendre : #{d[:custom_metadatas].inspect}"
      end

      return d
    end

  end #/Document

end #/module
