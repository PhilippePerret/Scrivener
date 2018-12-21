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
    @data = Data.new(self)
    data.paths= paths
    data.started_at = Time.now
    TableResultats::Proximite.init
    table_resultats.init
    texte_entier.init
  end

  # RETURN true si les données connues sont valides, pour pouvoir passer
  # à l'analyse du texte.
  def data_valid?
    # Un path doit absolument avoir été transmis à l'instanciation (vraiment ?)
    self.paths.is_a?(Array) || raise(ERRORS[:one_path_required])

    # On doit vérifier que chaque path existe. On en profite pour relever
    # leur date de dernière modification pour pouvoir régler le
    # :original_doc_modified_at si :modified_at n'est pas fourni
    arr_modified_at = Array.new
    self.paths.each do |p|
      File.exist?(p) || raise(ERRORS[:bad_path_provided] % data[:path])
      arr_modified_at << File.stat(p).mtime
    end

    self.original_doc_modified_at ||= arr_modified_at.max
    self.folder ||= File.expand_path(File.dirname(self.paths.first))
  end

  # Traitement des datas qui sont fournies à l'instanciation de
  # l'analyse
  # Noter que lorsqu'on checke seulement l'existence de l'analyse par exemple,
  # on n'a pas besoin de fournir de paths. Donc, ici, on prend seulement les
  # données fournies. On utilisera la méthode `data_valid?` pour savoir si les
  # données sont valides pour procéder à l'analyse.
  def treate_data data
    data ||= Hash.new

    # Les fichiers à traiter, s'ils sont envoyés lors de l'instanciation
    if data[:path]
      self.paths = [ data[:path] ]
    elsif data[:paths]
      self.paths = data[:paths]
    end

    # Le dossier de l'analyse. Il doit être possible de le déterminer
    # dès l'instanciation.
    self.folder =
      if data.key?(:folder)
        data[:folder]
      elsif self.paths && self.paths.is_a?(Array) && !self.paths.empty?
        File.expand_path(File.dirname(self.paths.first))
      else
        nil
      end

    # D'autres informations qui ont pu être passées par les données
    {
      title:        :title,
      modified_at:  :original_doc_modified_at
    }.each do |prop_from, prop_to|
      self.send('%s=' % prop_to, data[prop_from])
    end

  end

end #/Analyse
end #/TextAnalyzer
