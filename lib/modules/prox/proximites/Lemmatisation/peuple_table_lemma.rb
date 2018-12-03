=begin

  Toutes les méthodes Scrivener::Project utiles pour la lemmatisation
  du texte.

=end



class Scrivener
  class Project


    # Méthode qui prépare la table TABLE_LEMMATISATION à partir du fichier
    # +path+ obtenu par la commande `tree-tagger-french`
    #
    # Noter que le fichier data contient d'autres informations comme par
    # exemple la nature du mot, qui pourrait être utilisé ultérieurement
    def peuple_table_lemmatisation_from path
      CLI.dbg("-> Scrivener::Project#peuple_table_lemmatisation (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")

      # À présent, on peut récupérer les données de lemmatisation et en faire
      # une table qui sera utilisée avec la relève des mots.
      CLI.benchmark(:start, 'Définition de la table de lemmatisation')
      File.open(path).each_with_index do |line, index_line|
        original, nature, canon = line.strip.split("\t")
        original.length > 2   || next
        canon != '<unknown>'  || next
        if canon.nil?
          puts "--- CANON EST NUL DANS (ligne #{index_line}) : #{line}".red
          next
        end
        original = original.downcase
        if original != canon
          # Rectifications nécessaire
          canon = LEMMA_AJUSTEMENT_CANON[original] || canon
          # Rien à faire si le mot est déjà connu
          TABLE_LEMMATISATION.key?(original) && next
          # canon peut avoir la forme 'essayer|essayer'
          canon.index('|') && begin
            rien, canon = canon.split('|')
            original != canon || next
          end
          # On prend ce mot
          TABLE_LEMMATISATION.merge!(original => canon)
          CLI.dbg("    ---- #{original.downcase} -> #{canon}")
        end
      end
      CLI.benchmark(:stop)

    end
    # /peuple_table_lemmatisation_from

  end #/Project
end #/Scrivener
