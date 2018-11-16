class Scrivener
  class Project

    attr_accessor :last_document_mtime
    # = main =
    #
    # Lancement de la surveillance des proximités
    #
    def exec_watch_proximites

      prepare_surveillance
      exec_boucle_surveillance

    end
    # /exec_watch_proximites

    def prepare_surveillance

    end

    def exec_boucle_surveillance
      fin = false
      begin
        # On attend une modification du fichier
        sleep 1 # voir si c'est pas mieux d'utiliser un thread
        if new_document_mtime != last_document_mtime
          # <= Le document a changé
          # => Il faut analyser l'état actuel et le comparer à
          #    l'état précédent.
          check_etat_proximites_et_affiche_differences
        end
      end while !fin
      # Note : mais en fait, c'est CTRL-C qui interrompt le programme.
    end
    # /exec_boucle_surveillance


    def new_document_mtime
      File.stat(path_document_content_rtf).mtime
    end

    def path_document_content_rtf
      @path_document_content_rtf ||= File.join(path) # todo : régler
    end

  end #/Project
end #/Scrivener
