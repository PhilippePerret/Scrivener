# encoding: UTF-8
class TextAnalyzer
class Analyse

  # Instanciation d'une nouvelle analyse
  #
  # Une analyse est l'élément racine d'un analyse de textes, qu'elle provienne
  # d'un projet Scrivener ou d'un simple texte donné à analyser.
  #
  # +data+  {Hash} Donnée pour décrire l'analyse à faire. C'est ici par
  #         exemple qu'on pourrait définir que c'est un projet Scrivener.
  #         :path ou :file    Pour définir le path d'un fichier à analyser
  #                           S'il termine par l'extension .scriv, c'est un
  #                           projet Scrivener
  #         :folder       Peut indiquer le dossier dans lequel mettre l'analyse
  #                       C'est dans ce dossier que sera créé le dossier
  #                       `.textanalyzer`
  def initialize data = nil
    treate_data(data)
  end

  # Initialisation de l'analyse
  def init_analyse
    CLI.debug_entry
    data.started_at = Time.now
    TableResultats::Proximite.init
    table_resultats.init
    texte_entier.init
  end

  # Traitement des datas qui sont fournies à l'instanciation de
  # l'analyse
  def treate_data data
    data ||= Hash.new

    # Les fichiers à traiter, s'ils sont envoyés lors de l'instanciation
    data.key?(:file) && data.merge!(path: data.delete(:file))
    data[:path]  && self.paths = [ data[:path] ]
    data[:paths] && self.paths = data[:paths]

    # Le dossier de l'analyse. Il doit être possible de le déterminer
    # dès l'instanciation.
    self.folder = data[:folder] ||
      (
        data[:paths].first &&
        File.expand_path(File.dirname(data[:paths].first))
      ) ||
      raise(ERRORS[:one_path_required])

    # D'autres informations qui ont pu être passées par les données
    {
      title:        :title,
      modified_at:  :original_doc_modified_at
    }.each do |prop_from, prop_to|
      self.send('%s=' % prop_to, data[prop_from])
    end

    # Des informations
  end


end #/Analyse
end #/TextAnalyzer
