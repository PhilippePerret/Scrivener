# encoding: UTF-8
=begin

=end
class TextAnalyzer
class Analyse
class Data
class << self

  # Rechargement des données de l'analyse
  # Doit retourner une instance TextAnalyzer::Analyse::Data
  def load analyse
    # Si des résultats ont été enregistrés, on a besoin de la classe
    # du module. Noter qu'elle sera remplacée par la bonne suivant le
    # format voulu
    # require File.join(APPFOLDER,'lib/modules/output_by_type/text')
    # read_from_file(File.join(analyse.hidden_folder,'data.msh'), marshal: true)

    idata = TextAnalyzer::Analyse::Data.new(analyse)

    # Abandon de l'utilisation de Marshal pour YAML
    # Attention : on ne doit pas passer par `analyse.data`, car on ferait une
    # boucle infinie puisque cette méthode est appelée par data.
    if File.exist?(analyse.yaml_data_file)
      idata.data_from_yaml(read_from_file(analyse.yaml_data_file, {yaml: true}))
    end

    return idata
  end


end #/<< self
end #/Data
end #/Analyse
end #/TextAnalyzer
