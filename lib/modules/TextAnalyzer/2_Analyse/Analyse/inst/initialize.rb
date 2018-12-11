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
  def initialize data = nil
    treate_data(data)
  end

  # Traitement des datas qui sont fournies à l'instanciation de
  # l'analyse
  def treate_data data
    data ||= Hash.new
    data.key?(:file) && data.merge!(path: data.delete(:file))

    if data[:path]
      self.paths = [ data[:path] ]
    end
  end


end #/Analyse
end #/TextAnalyzer