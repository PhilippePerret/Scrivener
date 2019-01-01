# encoding: UTF-8

module BuildDocumentsModule
  class NewElement
    # = main =
    #
    # Méthode principale qui actualise l'élément à partir des données
    # fournies
    def update
      self.binder_item    = projet.binder_item_by_id(self.id)
      if self.binder_item
        # Modification du titre
        if self.titre != binder_item.title
          u = Update.new(self, binder_item, {type: :title, new_value: self.title})
          u.proceed
        end
        # Modification de l'objectif
        if self.target.to_i != binder_item.target.signs
          u = Update.new(self, binder_item, {type: :target, new_value: self.target.to_i, old_value: binder_item.target.signs})
          u.proceed
        end
        # TODO Autres données modifiées
      else
        # Par exemple un élément sans ID, un dossier par exemple
        puts 'Impossible de trouver le binder-item avec un ID de %s' % self.id.inspect
        # TODO Il faut peut-être le créer ?
      end
    end
    # /update
  end #/NewElement
end #/module
