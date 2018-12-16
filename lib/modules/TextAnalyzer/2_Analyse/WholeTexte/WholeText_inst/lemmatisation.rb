=begin

  Toutes les méthodes Scrivener::Project utiles pour la lemmatisation
  du texte.

=end
class TextAnalyzer
class Analyse
class WholeText

  # Certaines valeurs sont mal corrigées par TreeTagger. Par exemple, 'lui' est
  # compris comme participe passé de 'luire', même dans la phrase "Son nom allait
  # désormais la salir comme lui." (Madame Bovary, Gustave Flaubert)
  LEMMA_AJUSTEMENT_CANON = {
    # Il arrive, si une erreur d'OCR s'est produite, que 'dans' arrive juste
    # avant un point ("dans.") et dans ce cas il est interprété comme le
    # pluriel de 'dan'.
    'dans'  => 'dans',
    'lui'   => 'lui' # au lieu de luire
  }

  TABLE_LEMMATISATION = Hash.new

  # Lemmatisation du texte entier
  #
  # La lemmatisation correspond à l'analyse du texte par tree-tagger puis
  # au peuplement de la table volatile TABLE_LEMMATISATION qui contient
  # tous les mots et leur canon correspondant
  def lemmatize
    CLI.debug_entry
    CLI.benchmark(:start, 'Lemmatisation du texte')
    `tree-tagger-french < #{path} > #{lemma_file_path} 2>/dev/null`
    CLI.benchmark(:stop)

    CLI.benchmark(:start, 'Définition de la table de lemmatisation')
    peuple_table_lemma
    CLI.benchmark(:stop)

  end

    # Méthode qui prépare la table TABLE_LEMMATISATION à partir du fichier
    # +path+ obtenu par la commande `tree-tagger-french`
    #
    # Noter que le fichier data contient d'autres informations comme par
    # exemple la nature du mot, qui pourrait être utilisé ultérieurement
    def peuple_table_lemma
      CLI.debug_entry
      # À présent, on peut récupérer les données de lemmatisation et en faire
      # une table qui sera utilisée avec la relève des mots.
      File.open(lemma_file_path).each_with_index do |line, index_line|
        d = line.strip.split("\t")
        original = d.first ; canon = d.last
        original.length > 2   || next
        canon != '<unknown>'  || next
        if canon.nil?
          puts "--- CANON EST NUL DANS (ligne #{index_line}) : #{line}".red
          next
        end
        original = original.downcase
        if original != canon
          # Rectifications nécessaire
          if LEMMA_AJUSTEMENT_CANON.key?(original)
            canon = LEMMA_AJUSTEMENT_CANON[original]
          end
          # Rien à faire si le mot est déjà connu
          TABLE_LEMMATISATION.key?(original) && next

          # canon peut avoir la forme 'essayer|essayer'
          canon.index('|') && begin
            canon = canon.split('|')[1]
            original != canon || next
          end
          # On prend ce mot
          TABLE_LEMMATISATION.merge!(original => canon)
          CLI.dbg("    ---- #{original.downcase} canon-> #{canon}")
        end
      end
    end
    # /peuple_table_lemma

end #/WholeText
end #/Analyse
end #/TextAnalyzer
