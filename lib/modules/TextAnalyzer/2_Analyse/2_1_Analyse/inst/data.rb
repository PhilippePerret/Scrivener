# encoding: UTF-8
class TextAnalyzer
class Analyse


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

  # L'instance contenant les données générales de l'analyse
  def data
    @data ||= begin
      provdata = Data.new(self)
      if provdata.exist?
        TextAnalyzer::Analyse::Data.load(self)
      else
        provdata
      end
    end
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

  # Définit et retourne le dossier de l'analyse (le dossier du projet, en
  # réalité)
  # Noter qu'il a pu être défini à l'instanciation.
  def folder
    @folder ||= begin
      self.paths                    || raise
      self.paths.first              || raise
      File.exist?(self.paths.first) || raise
      File.expand_path(File.dirname(self.paths.first))
    rescue Exception
      raise(ERRORS[:folder_uncalcable])
    end
  end

  # Le dossier caché de l'analyse, pour mettre tous les fichiers utiles et
  # produits.
  # Pour le trouver, on utilise le premier path de texte à traiter. C'est
  # par exemple le projet Scrivener.
  # Note : on construit le dossier s'il n'existe pas (et toute sa hiérarchie).
  def hidden_folder
    @hidden_folder ||= begin
      d = File.join(folder, '.textanalyzer')
      `mkdir -p "#{d}"`
      d
    end
  end

end #/Analyse
end #/TextAnalyzer
