=begin

  Méthodes de classe communes

=end
class ProxMot
  class << self

    # Retourne le mot d'identifiant +mot_id+ dans le projet courant.
    #
    # Noter que pour pouvoir l'obtenir, il faut obligatoirement qu'une
    # analyse du texte ait été effectuée. Donc que le tableau_proximites du
    # projet soit défini.
    #
    def get mot_id
      project || raise_no_project
      project.tableau_proximites.nil? && raise_no_analyse_proximites
      @mots[mot_id]
    end

    def add imot
      @mots ||= Hash.new
      @mots.merge!(imot.index => imot)
    end

    # ---------------------------------------------------------------------
    #   GESTION DES ERREURS

    def raise_no_project
      raise('Aucun projet n’est défini. Il est impossible de renvoyer les informations d’un mot.')
    end
    def raise_no_analyse_proximites
      raise('Avant de pouvoir obtenir les données d’un mot, il faut lancer l’analyse des proximités du projet.')
    end

  end #/<< self
end#/ProxMot