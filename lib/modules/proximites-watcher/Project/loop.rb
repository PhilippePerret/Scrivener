class Scrivener
  class Project

    def exec_boucle_surveillance
      CLI.dbg("-> Scrivener::Project#exec_boucle_surveillance (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
      fin = false
      begin
        # On attend une modification du fichier
        sleep 1 # voir si c'est pas mieux d'utiliser un thread
        # Quand le document a changé, il faut analyser l'état actuel et
        # le comparer à l'état précédent.
        if changement_has_occured?
          check_etat_proximites_et_affiche_differences
        end
      end while !fin
      # Note : mais en fait, c'est CTRL-C qui interrompt le programme.
      CLI.dbg("<--- Scrivener::Project#exec_boucle_surveillance (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
    end
    # /exec_boucle_surveillance

    # Retourne true si un changement est survenu dans les binder-item,
    # c'est-à-dire si leur mtime a changé depuis la dernière vérification
    def changement_has_occured?
      CLI.dbg("-> Scrivener::Project#changement_has_occured? (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
      watched_binder_items.each do |bitem|
        if bitem.has_changed? then
          # Comme on va procéder à la vérification, on doit marquer la nouvelle
          # date pour les trois fichiers, pour ne pas faire trois fois
          # l'opération.
          watched_binder_items.each do |bitem|
            bitem.set_current_mtime
            # On en profite pour initialiser des valeurs importantes
            bitem.instance_variable_set('@texte', nil)
            # puts "--- Texte de #{bitem.uuid} : #{bitem.texte}"
          end
          CLI.dbg("<- Scrivener::Project#changement_has_occured? (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
          return true
        end
      end
      CLI.dbg("<- Scrivener::Project#changement_has_occured? (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
      return false
    end
    # /changement_has_occured?


  end #/Project
end #/Scrivener
