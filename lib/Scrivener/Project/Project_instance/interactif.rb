# encoding: UTF-8
class Scrivener
  class Project

    # Pour plusieurs commandes, il faut demander si le projet est
    # bien fermé avant de procéder.
    # La méthode retourne True si on peut continuer
    def ask_for_fermeture
      yesOrNo('Le projet est-il bien fermé dans Scrivener ? C’est indispensable.', {invite: 'Projet fermé ?'})
    end


    # Pour ouvrir le projet (dans Scrivener)
    def open
      `open "#{path}"`
    end

  end #/Project
end #/Scrivener
