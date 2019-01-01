# encoding: UTF-8

module BuildDocumentsModule
  class NewElement

    attr_accessor :projet
    attr_accessor :container
    attr_accessor :data_line, :args
    attr_accessor :titre # cf. aussi la méthode :title ci-dessous
    attr_accessor :level # cf. aussi la méthode :level ci-dessous
    # {BinderItem} Le bi résultant de la création de cet élément
    attr_accessor :binder_item


    # TODO : s'il y a une colonne "résumé"

    # ---------------------------------------------------------------------
    # Les data

    def title   ; self.titre end
    def niveau  ; self.level end
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
