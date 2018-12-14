class TextAnalyzer
class Analyse
class TableResultats
class Proximite
  class << self

    # = Initialisation des listes =
    def init
      # On initialise les listes de proximité
      prepare_liste_rectifiees
      # prepare_liste_proximites_projet TODO À REMETTRE
    end
    # /init

    def prepare_liste_rectifiees
      h = TextAnalyzer::PROXIMITES_MAX
      hash_mots = Hash.new
      h.each do |k_distance, liste_mots|
        liste_mots.each {|mot| hash_mots.merge!(mot => k_distance)}
      end
      TextAnalyzer::PROXIMITES_MAX[:mots] = hash_mots
      #/fin de boucle sur toutes les distances rectifiées
    end
    # /prepare_liste_rectifiees

    # Préparation de la liste des mots propre au projet, à distance particulière
    def prepare_liste_proximites_projet
      File.exists?(proximites_file_path) || begin
        debug 'Pas de liste proximités propre au texte (le fichier %s n’existe pas)' % proximites_file_path
        return
      end

      proximite_maximale = -1
      File.open(proximites_file_path,'rb').each do |line|
        line.start_with?('#') && next
        if line =~ /[0-9]+/
          proximite_maximale = line.to_i
        else
          mot = line.strip.downcase
          TextAnalyzer::PROXIMITES_MAX[:mots].merge!(mot => proximite_maximale)
        end
      end
    end
    # /prepare_liste_proximites_projet

  end #/ << self
end #/Proximite
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
