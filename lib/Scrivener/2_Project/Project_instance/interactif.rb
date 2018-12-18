# encoding: UTF-8
class Scrivener
  class Project

    # Pour plusieurs commandes, il faut demander si le projet est
    # bien fermé avant de procéder.
    # La méthode retourne True si on peut continuer
    def ask_for_fermeture
      yesOrNo(QUEST[:is_project_closed], {invite: QUEST[:invite_project_close]})
    end

    def ask_for_ouverture
      yesOrNo(QUEST[:open_project_in_scrivener]) && begin
        Scrivener.require_module('open')
        self.open(nil)
      end
    end

  end #/Project
end #/Scrivener
