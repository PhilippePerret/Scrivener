# encoding: UTF-8
class TextAnalyzer
class Analyse

  # Pour la gestion des données enregistrées et loadées
  include ModuleForFromYaml

  # {String} Le chemin d'accès au dossier qui contiendra le dossier
  # caché de l'analyse
  attr_writer :folder

  # {Array} des paths de fichier (String) à analyser et
  # {Array} des fichiers (instances TextAnalyzer::File) à analyser
  attr_accessor :paths, :files

  # {Time} Date de dernière modification du document de référence
  # (par exemple le projet Scrivener).
  # Attention, il ne s'agit pas du document texte complet.
  attr_accessor :original_doc_modified_at

  # Les données de l'analyse, sous forme de code YAML
  def yaml_properties
    {
      datas: {
        title:                    {type: YAPROP},
        folder:                   {type: YAPROP},
        paths:                    {type: YAPROP},
        # files:                  {type: },
        original_doc_modified_at: {type: YAPROP},
        text_analyzer_version:    {type: YIVAR}
      }
    }
  end

  # L'instance contenant les données générales de l'analyse
  # Noter que pour les recharger, il faut explicitement appeler la
  # méthode reload (soit de l'analyse, soit de ce data)
  def data
    @data ||= TextAnalyzer::Analyse::Data.new(self)
  end

  def text_analyzer_version
    @text_analyzer_version ||= TextAnalyzer.version
  end

  # L'instance contenant tous les résultats de l'analyse
  # Note : pour charger les données qui sont enregistrées dans le fichier,
  # pour le moment, on doit faire `<analyse>.table_resultats.get`
  def table_resultats
    @table_resultats ||= TextAnalyzer::Analyse::TableResultats.new(self)
  end

  # Le texte entier de l'analyse
  def texte_entier
    @texte_entier ||= TextAnalyzer::Analyse::WholeText.new(self)
  end

  # Date de dernière modification de cette analyse. C'est donc la date de
  # création de l'analyse (sa date de fin).
  def modified_at
    @modified_at ||= self.data.ended_at
  end

  # # Titre du projet de l'analyse
  # # Soit on la définit explicitement lors de l'instanciation, soit on
  # # le calcul en fonction du nom du dossier
  # # {String} Le titre du projet
  def title
    @title ||= File.basename(folder)
  end
  def title= value
    @title = value
  end

  def canons
    table_resultats.canons
  end

  def proximites
    table_resultats.proximites
  end

  # Retourne l'instance TextAnalyzer::File du fichier de l'analyse
  # courante d'identifiant +object_id+
  # Question : est-ce que ça sert encore ?
  def get_file object_id
    files[object_id]
  end

end #/Analyse
end #/TextAnalyzer
