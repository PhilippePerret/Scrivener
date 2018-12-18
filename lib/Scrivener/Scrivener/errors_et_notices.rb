# encoding: UTF-8
class Scrivener

  ERRORS_MSGS = {
    project_path_required: 'Il faut définir le projet Scrivener à traiter, en indiquant le chemin depuis votre dossier utilisateur (%s).',
    bad_project_extension: 'L’extension du projet devrait être «.scriv» (c’est «%s»)',
    unfound_project: 'Le projet «%s» est introuvable. Merci de vérifier le chemin.',
    unknown_command: 'La commande `%s` est inconnue. Utiliser `scriv commands` pour obtenir la liste des commandes et `scriv <command> -h` pour obtenir de l’aide sur une commande particulière.'
  }

  ERRORS = Hash.new

  NOTICES = Hash.new
  NOTICES.merge!(
    require_project_closed: 'Cette opération nécessite que le projet soit absolument fermé.'
  )

  QUEST = {
    is_project_closed:          'Le projet est-il bien fermé dans Scrivener ? C’est indispensable.',
    invite_project_close:       'Projet fermé ?',
    open_project_in_scrivener:  'Faut-il ouvrir le projet dans Scrivener ?'
  }

end #/Scrivener
