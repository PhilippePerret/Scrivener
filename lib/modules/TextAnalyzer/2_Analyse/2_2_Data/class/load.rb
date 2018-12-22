# encoding: UTF-8
=begin

=end
class TextAnalyzer
class Analyse
class Data
class << self

  # Rechargement des données de l'analyse
  def load analyse
    # Si des résultats ont été enregistrés, on a besoin de la classe
    # du module. Noter qu'elle sera remplacée par la bonne suivant le
    # format voulu
    require File.join(APPFOLDER,'lib/modules/modules_output_by_type/text')
    Marshal.load(File.open(File.join(analyse.hidden_folder,'data.msh'),'rb'))
  end

end #/<< self
end #/Data
end #/Analyse
end #/TextAnalyzer
