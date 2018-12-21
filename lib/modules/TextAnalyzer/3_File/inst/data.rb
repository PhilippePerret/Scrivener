# encoding: UTF-8
class TextAnalyzer
class AnalyzedFile

  # On identifiant, en commençant à 0
  # Son formated_id est mis à __DOC<id sur 3 chiffres>__ pour insertion
  # dans le texte complet.
  attr_accessor :id

  # Index du File dans son analyse. Pour pouvoir les récupérer dans
  # l'ordre, entendu que Analyse#files est une table avec l'object_id
  # du File en clé et l'instance en valeur.
  # Note : on pourrait aussi se servir du @id ci-dessus.
  attr_accessor :index

  # Chemin d'accès au fichier contenant le texte à analyser
  attr_accessor :path

  # {TextAnalyzer::Analyse} L'analyse en cours, ou nil si le fichier
  # n'est pas analysé dans le cadre d'une analyse de texte
  attr_accessor :analyse

  # {Fixnum} Décalage, dans le fichier du texte complet, de ce
  # fichier (pour retrouver les documents des mots)
  attr_accessor :offset

  # Instance {TextAnalyzer::File::Text} du texte du fichier
  def texte
    @texte ||= File.read(path)
  end

  def affixe
    @affixe ||= File.basename(path, File.extname(path))
  end

end #/AnalyzedFile
end #/TextAnalyzer
