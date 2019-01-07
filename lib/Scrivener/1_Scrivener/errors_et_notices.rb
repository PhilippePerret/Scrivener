# encoding: UTF-8
class Scrivener

  ERRORS = {
    unknown_module_required:  'Le module `%s` est introuvable…',
    project_path_required:    'Il faut définir le projet Scrivener à traiter, en indiquant le chemin depuis votre dossier utilisateur (%s).',
    bad_project_extension:    'L’extension du projet devrait être «.scriv» (c’est «%s»)',
    paths_required_for_analyse:  'Il faut impérativement communiquer les chemins d’accès aux fichiers pour procéder à l’analyse textuelle.',
    unfound_project:          'Le projet «%s» est introuvable. Merci de vérifier le chemin.',
    unknown_command:          'La commande `%s` est inconnue. Utiliser `scriv commands` pour obtenir la liste des commandes et `scriv <command> -h` pour obtenir de l’aide sur une commande particulière.',
    document_title_required:  'Le titre du document du mot doit être donné (en paramètre : `doc="<début titre>"` ou en option : `-doc="<début titre>"`)',
    no_document:              'Aucun document dont le nom est ou commence par « %s » n’a été trouvé parmi les documents :',
    no_proximites:            'Aucune proximité n’est à afficher.',
    unproximable_objet:       'Je ne sais pas afficher en deux pages les proximités d’un élément :%s'
  }

# === ERREURS D'ARGUMENT(S) ===
ERRORS.key?(:args) || ERRORS.merge!(args: Hash.new)
# ERRORS[:args].merge!(
#
# )
# === ERREURS AVEC LES BINDER-ITEMS ===
ERRORS.key?(:binder_item) || ERRORS.merge!(binder_item: Hash.new)
ERRORS[:binder_item].merge!(
  unfound_with_title: 'Aucun document du projet ne semble posséder un document dont le titre commence par « %s »…'
)


NOTICES = Hash.new
NOTICES.merge!(
  require_project_closed:       'Cette opération nécessite que le projet soit absolument fermé.',
  maybe_only_leading_doctitle:  'Rappel : vous pouvez indiquer seulement le début du titre du document.'
)

  QUEST = {
    is_project_closed:          'Le projet est-il bien fermé dans Scrivener ? C’est indispensable.',
    invite_project_close:       'Projet fermé ?',
    open_project_in_scrivener:  'Faut-il ouvrir le projet dans Scrivener ?'
  }

end #/Scrivener
