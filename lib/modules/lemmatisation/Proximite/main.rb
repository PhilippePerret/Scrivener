class Proximite
class << self

  # = main =
  #
  # Méthode principale appelée par la commande `scriv lemma`
  #
  # Si c'est une opération qui nécessite un projet, on doit appeler la
  # méthode `Project.must_exist(Scrivener.project_path)` pour s'assurer que
  # le projet est bien défini.
  #
  def exec_lemmatisation
    if CLI.params[1] == 'abbreviations'
      if CLI.options[:initial]
        Proximite.retrieve_original_abbreviations
      else
        Proximite.open_file_abbreviations # s'il existe, sinon erreur
      end
    end
  end

end #/ << self
end #/Proximite
