# encoding: UTF-8
class Scrivener
ERRORS[:build]  ||= Hash.new
ERRORS[:update] ||= Hash.new

# === UPDATE ===
ERRORS[:update].merge!({
  id_column_required: 'Pour actualiser un projet, il faut impérativement une colonne d’identifiant (ID) pour retrouver les éléments.',
  unenable_to_update_value: 'Impossible d’actualiser la donnée de type "%s"'
})
# === BUILD ===
ERRORS[:build].merge!({
  # Documents
  default_source_unfoundable:  'Sans option --from=<...> définissant la document source, il faut que ce document source porte le nom "tdm.csv" et qu’il se trouve dans le dossier du projet.',
  no_source:          'Un document source est absolument requis (ajouter l’option `--from=<path/to/source>`)',
  source_unfound:     'Impossible de trouver le fichier %s…',
  empty_source:       'Le document source %s ne contient malheureusement aucune donnée.',
  bad_cells_count:    'La ligne %s ne contient pas le bon nombre de cellules (%i contre %i attendues)',
  delimitor_required: 'Il n’y a qu’une seule donnée par ligne. Un délimiteur est visiblement requis (ajouter l’option --delimitor="<del>")',
  double_colonne_targets:  'Deux colonnes peuvent contenir des objectifs. Précisez à l’aide de l’entête des labels laquelle doit être utilisée comme vraie colonne des objectifs.',
  depth_required_for_test: 'Dans ce cas, il faut impérativement définir la profondeur',
  # Reprendre ci-dessus une des phrases utilisées dans le texte ci-dessous
  # (pour les tests)
  depth_required: '
  La première colonne n’étant pas intégralement remplie, j’en
  déduis qu’il y a des imbrications de dossiers/documents.
  Dans ce cas, il faut impérativement définir la profondeur
  avec l’option `--depth` ou l’option `--profondeur`.
  S’il y a seulement un premier niveau de dossier :
    Dossier 1 –––
                 | Document 1
                 | Document 2
    Dossier 2 ___
                 | Document 3
  … alors la profondeur est de 2, il faut utiliser :
    `--depth=2` ou `--profondeur=2`
  ',
  two_depth_on_same_line_for_test: 'Double valeur d’imbrication pour une même ligne',
  # Reprendre ci-dessus la première ligne ci-dessous
  two_depth_on_same_line: '
  Double valeur d’imbrication pour une même ligne : ligne %i : %s.
  La profondeur étant de %i, on ne devrait trouver qu’un seul ti-
  tre (de dossier ou de document) sur les %i premières cellules de
  chaque ligne de données.
  '
})
class Project
class << self
  # Retourne la liste humaine des choses constructible avec la
  # commande build
  def buildable_things_hlist
    @buildable_things_hlist ||= BUILDABLE_THINGS.collect{|t,d| t.to_s}.pretty_join
  end

  def raise_thing_required
    raise(ERRORS[:build][:thing_required])
  end
  private :raise_thing_required
  def raise_invalid_thing
    raise(ERRORS[:build][:invalid_thing] % [thing, buildable_things_hlist])
  end
  private :raise_invalid_thing
end #<< self
# ---------------------------------------------------------------------
#   INSTANCES
def raise_source_default_unfoundable
  raise(ERRORS[:build][:default_source_unfoundable])
end
def raise_no_source_document
  raise(ERRORS[:build][:no_source])
end
def raise_source_unfoundable(path)
  raise(ERRORS[:build][:source_unfound] % path.inspect)
end
def raise_empty_document_source(path)
  raise(ERRORS[:build][:empty_source] % path.inspect)
end
def raise_bad_nombre_cellules(line, nb, nb_expected)
  raise(ERRORS[:build][:bad_cells_count] % [line.inspect, nb, nb_expected])
end
def raise_delimitor_required
  raise(ERRORS[:build][:delimitor_required])
end
def raise_double_colonnes_target
  raise(ERRORS[:build][:double_colonne_targets])
end
def raise_depth_required
  raise(ERRORS[:build][:depth_required])
end
def raise_double_value_profondeur(lig, idx_in_file)
  raise(ERRORS[:build][:two_depth_on_same_line] % [idx_in_file, lig, building_settings.depth, building_settings.depth])
end
def id_column_exist_pour_update_or_raise
  building_settings.id_column || raise(ERRORS[:update][:id_column_required])
end

end #/Project
end#/Scrivener
