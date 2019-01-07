# encoding: UTF-8
class Scrivener
ERRORS.merge!(
  unknown_method:             'La propriété `%s`, si elle existe, ne peut être définie avec la commande `set`.',
  no_binder_item_with_titre:  'Aucun document du projet ne semble posséder un document dont le titre commence par « %s »…',
  yaml_file_unfound:          'Le fichier YAML "%s" contenant les données à régler est introuvable.'
)
end #/Scrivener
