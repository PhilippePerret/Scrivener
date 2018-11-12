=begin
  Module s'occupant des corrections à opérer, par exemple lorsque l'utilisateur
  change une proximité.
=end
class ProxMot

end #/ProxMot


class Proximite


  def cli_correction_proximite console
    console.msg('p: Modifier le mot avant | n: Modifier le mot après | i: Ignorer cette proximité | q: Renonce')
    touche = console.wait_for_commande
    case touche
    when 'q' then return
    when 'n', 'p'
      old_mot = touche == 'n' ? self.mot_apres.real : self.mot_avant.real
      incipit = 'Par quoi remplacer le mot « %s » : ' % [old_mot]
      # choix = console.wait_for_commande
      new_mot = ''
      begin
        console.msg(incipit + new_mot)
        skey = console.wait_for_commande
        if skey == 10
          break
        else
          new_mot += skey
        end
      end while skey != 10
      if console.confirmation?('Faut-il vraiment remplacer « %s » par « %s » ?' % [old_mot, new_mot])
        console.msg('OK, je remplace')
      end
    when 'i'
      fix(ignore: true)
      console.msg('Cette proximité sera ignorée.', :info)
    end
    # if console.confirmation?('Pour confirmer la correction, presser la touche ENTRÉE')
    #   msg('Il faut implémenter la correction', {type: :warning, sleep: 4})
    # end
  end

  # Méthode pour corriger la proximité
  #
  # @param attrs Hash
  #   :new_mot_avant      Le nouveau mot avant
  #   :new_mot_apres      Le nouveau mot après
  #   :ignore             On doit ignorer cette proximité
  #
  def fix attrs

    if attrs[:ignore]
      self.ignored = true
      project.tableau_proximites[:nombre_proximites_ignored] += 1
      return # pour ne pas marquer corrigé
    elsif attrs[:new_mot_avant]
      mot_avant.remplace_par(attrs[:new_mot_avant])
    elsif attrs[:new_mot_apres]
      mot_apres.remplace_par(attrs[:new_mot_apres])
    end

    # TODO Pour le moment, on indique que la proximité est corrigée, mais
    # il faudra vérifier mieux que ça
    self.fixed = true
    project.tableau_proximites[:nombre_proximites_fixed] += 1
  end
  # /fix

end #/Proximite
