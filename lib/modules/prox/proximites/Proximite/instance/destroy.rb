class Proximite

  def destroy
    debug('* Destruction de la proximité \#%i' % self.id)
    self.erased = true
    self.mot_avant.proximite_apres= nil
    self.mot_apres.proximite_avant= nil
    canon = self.mot_avant.canonique
    project.analyse.table_resultats.proximites.delete(self.id)
    project.tableau_proximites[:nombre_proximites_erased] += 1
    # Il faut aussi supprimer l'ID dans la liste :proximites du mot
    debug '* Retrait de la prox d’ID #%i pour le mot canonique «%s»' % [self.id, canon]
    debug '  = Liste project.tableau_proximites[:mots][canon] : %s' % project.tableau_proximites[:mots][canon].inspect
    debug 'Liste des IDs de proximité du mot «%s» avant suppression : %s' % [canon, project.tableau_proximites[:mots][canon][:proximites].inspect]
    project.tableau_proximites[:mots][canon][:proximites].delete(self.id)
    debug 'Liste des IDs de proximité du mot «%s» APRÈS suppression : %s' % [canon, project.tableau_proximites[:mots][canon][:proximites].inspect]
    # On marque le projet modifié
    project.tableau_proximites[:modified_at] = Time.now
    debug('= Proximité #%i détruite avec succès' % self.id)
  end

end #/Proximite
