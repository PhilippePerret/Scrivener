# encoding: UTF-8
class Scrivener
  class Project

    # Pour plusieurs commandes, il faut demander si le projet est
    # bien fermé avant de procéder.
    # La méthode retourne True si on peut continuer
    def ask_for_fermeture
      yesOrNo(t('projects.questions.is_project_closed'), {invite: t('projects.questions.invite_project_close')})
    end

    def ask_for_ouverture
      yesOrNo(t('projects.questions.open_the_project')) && begin
        Scrivener.require_module('open')
        self.open(nil)
      end
    end

  end #/Project
end #/Scrivener
