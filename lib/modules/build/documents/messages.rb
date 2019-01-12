# encoding: UTF-8
class Scrivener
class Project
# ---------------------------------------------------------------------
#   INSTANCES
def raise_source_default_unfoundable
  rt('commands.build.errors.default_source_unfoundable')
end
def raise_no_source_document
end
def raise_source_unfoundable(path)
  rt('commands.build.errors.source_unfound', {pth: path})
end
def raise_empty_document_source(path)
end
def raise_bad_nombre_cellules(line, nb, nb_expected)
  rt('commands.build.errors.bad_cells_count', {line: line.inspect, nb_actual: nb, nb_expected: nb_expected})
end
def raise_delimitor_required
  rt('commands.build.errors.delimitor_required')
end
def raise_double_colonnes_target
  rt('commands.build.errors.double_colonne_targets')
end
def raise_depth_required
  rt('commands.build.errors.depth_required')
end
def raise_double_value_profondeur(lig, idx_in_file)
  rt('commands.build.errors.two_depth_on_same_line', {line_index: idx_in_file, line: lig, depth: building_settings.depth})
end
def id_column_exist_pour_update_or_raise
  building_settings.id_column || rt('commands.update.errors.id_column_required')
end

end #/Project
end#/Scrivener
