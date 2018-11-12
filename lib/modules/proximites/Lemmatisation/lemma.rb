=begin

  Toutes les méthodes Scrivener::Project utiles pour la lemmatisation
  du texte.

=end
class Scrivener
  class Project


    # Méthode qui prépare la lémmatisation.
    # Synopsis :
    #   - reconstitution de la totalité du texte dans un fichier unique
    #   - traitement des lèmmes de ce fichier pour produire un fichier data
    #     dont chaque ligne contient l'information sur les mots.
    #   - lecture de ce fichier de données pour produire une table de
    #     correspondance propre au texte (table[<mot>] => <mot canonique>)
    #     Cette table s'appelle la TABLE_LEMMATISATION
    #   - Enregistrement de cette table de lémmisation pour utilisation
    #     ultérieure sans avoir à tout relire.
    #
    # Noter que le fichier data contient d'autres informations comme par
    # exemple la nature du mot.
    def prepare_lemmatisation
      CLI.dbg("-> Scrivener::Project#prepare_lemmatisation (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")

      # La toute première chose à faire est de faire un texte unique
      # avec tous les binder-items du manuscrit
      # Cela produit le fichier '.scriv/whole_texte.txt' (whole_text_path)
      CLI.benchmark(:start, 'Assemblage du texte complet')
      assemble_textes_binder_items
      CLI.benchmark(:stop)

      # Ensuite, il faut prendre ce texte et en tirer les données de
      # lemmatisation complètes, qui seront mises dans .scriv/lemmatisation_data
      CLI.benchmark(:start, 'Lemmatisation du texte')
      `tree-tagger-french < #{whole_text_path} > #{lemma_data_path}`
      CLI.benchmark(:stop)

      # À présent, on peut récupérer les données de lemmatisation et en faire
      # une table qui sera utilisée avec la relève des mots.
      CLI.benchmark(:start, 'Définition de la table de lemmatisation')
      File.open(lemma_data_path).each_with_index do |line, index_line|
        original, nature, canon = line.strip.split("\t")
        original.length > 2   || next
        canon != '<unknown>'  || next
        if canon.nil?
          puts "--- CANON EST NUL DANS (ligne #{index_line}) : #{line}".red
          next
        end
        original = original.downcase
        if original != canon
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

      # On sauve la table pour utilisation ultérieure
      save_table_lemmatisation
    end
    # /prepare_lemmatisation

  end #/Project
end #/Scrivener
