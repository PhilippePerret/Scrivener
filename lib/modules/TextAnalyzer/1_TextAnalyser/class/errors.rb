# encoding: UTF-8
class TextAnalyzer

  ERRORS = {
    folder_uncalcable:        'Impossible de définir le dossier de l’analyse… (non définition et pas de paths)',
    nb_doc2treate_unmatch:    'Le nombre de paths à traiter dans l’assemblage (%i) du texte ne correspond pas au nombre effectivement traité (%i)…',
    bad_path_provided:        'Le fichier "%s" est introuvable…',
    one_path_required:        'Il faut au moins spécifier un chemin d’accès de fichier',
    no_table_resultats:       'Aucune table de résultats (fichier Marshal) n’existe pour cette analyse',
    require_table_resultats:  'Une instance tableau de résultat est requise.',
    no_files_to_analyze:      'Aucun fichier à analyser.',
    unfound_word:             'Impossible de trouver le mot "%s" (%s)'
  }

  ERRORS.key?(:proximites) || ERRORS.merge!(proximites: Hash.new)
  ERRORS[:proximites].merge!(
    no_text:          'Aucun texte à analyser…'
  )

end #/TextAnalyzer
