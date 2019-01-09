# encoding: UTF-8
class Scrivener
ERRORS[:build] ||= Hash.new
ERRORS[:build].merge!(
custom_metadatas:{
  yaml_file_unfound:  'Le fichier YAML "%s" est introuvable.',
  options_required:   'Les options (items de liste) sont obligatoires pour définir une donnée personnalisée de type liste. C’est une liste (Array) constituée de paires [valeur, titre].',
  no_yaml_code:       'Le code YAML du fichier transmis ne semble pas être du code YAML valide.',
  yaml_invalid_code:  'Le code YAML du fichier transmis est invalide : %s. Merci de consulter l’aide (`scriv build metadatas -h`).',

  type_invalid:       'Le type "%s" est un type invalide.',
  title_undefined:    'Le nom de la métadonnée d’ID "%s" doit être défini (avec au choix name:, nom:, titre: ou title:)'
}
)
DESIGNATIONS = {
  fr:  {
    must_be_an_hash: 'doit être une table de hashage',
    must_be_an_array: 'doit être une liste'
  },
  en: {
    must_be_an_hash: 'must be an hash',
    must_be_an_array: 'must be an array'
  }
}

class Project
def raise_yaml_file_unfound(pth)
  raise_err_with(:yaml_file_unfound, pth)
end
def raise_no_code_yaml
  raise_err_with(:no_yaml_code)
end
def raise_code_yaml_invalid(spec_err)
  raise_err_with(:yaml_invalid_code, DESIGNATIONS[lang][spec_err])
end
# ---------------------------------------------------------------------
def lang
  @lang ||= ENV['SCRIV_LANG'].to_sym
end
def raise_err_with(err_id, *args)
  err = ERRORS[:build][:custom_metadatas][err_id]
  raise(err % args)
end
end #/Project
end #/Scrivener

module BuildMetadatasModule
class MetaData
def raise_type_invalid(type)
  project.raise_err_with(:type_invalid, type)
end
def raise_title_undefined(key)
  project.raise_err_with(:title_undefined, key)
end
def raise_options_required_for_cm_list
  project.raise_err_with(:options_required)
end
end #/MetaData
end #/module
