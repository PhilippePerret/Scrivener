# encoding: UTF-8
class TextAnalyzer

  ERRORS = {
    one_path_required:        'Il faut au moins spécifier un chemin d’accès de fichier',
    no_table_resultats:       'Aucune table de résultats (fichier Marshal) n’existe pour cette analyse',
    require_table_resultats:  'Une instance tableau de résultat est requise.',
    no_files_to_analyze:      'Aucun fichier à analyser.',
    unfound_word:             'Impossible de trouver le mot "%s" (%s)'
  }

end #/TextAnalyzer
