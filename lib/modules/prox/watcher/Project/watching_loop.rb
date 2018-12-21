class Scrivener
  class Project

    def exec_boucle_surveillance
      CLI.debug_entry
      fin = false
      begin
        # puts "-- J'ENTRE DANS LA BOUCLE DE SURVEILLANCE"
        # On attend une modification du fichier
        sleep 1
        # Quand le document a changé, il faut analyser l'état actuel et
        # le comparer à l'état précédent.
        if changement_has_occured?
          check_etat_proximites_et_affiche_differences
        end
      end while !fin
      # Note : mais en fait, c'est CTRL-C qui interrompt le programme.
      CLI.debug_exit
    end
    # /exec_boucle_surveillance

    # Retourne true si un changement est survenu dans les binder-item,
    # c'est-à-dire si leur mtime a changé depuis la dernière vérification
    def changement_has_occured?
      watched_binder_items.each do |bitem|
        if bitem.has_changed? then
          # Comme on va procéder à la vérification, on doit marquer la nouvelle
          # date pour tous les fichiers, pour ne pas faire trois fois
          # l'opération.
          watched_binder_items.each do |sbitem|
            sbitem.set_current_mtime
            # On en profite pour initialiser des valeurs importantes
            sbitem.instance_variable_set('@texte', nil)
            # puts "--- Texte de #{bitem.uuid} : #{bitem.texte}"
          end
          return true
        end
      end
      return false
    end
    # /changement_has_occured?


  end #/Project
end #/Scrivener
