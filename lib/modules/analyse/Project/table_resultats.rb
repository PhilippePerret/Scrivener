class Scrivener
class Project

  # On récupère les données de proximités
  # Soit on les prend des fichiers déjà produits et enregistrés s'ils
  # existent, soient on calcule tout.
  def get_data_proximites
    CLI.debug_entry
    if analyse.exist? && !CLI.options[:force]
      analyse.reload
      CLI.options[:force_calcul] && analyse.force_recalcul
    else
      analyse.exec
    end
    CLI.debug_exit
  end

end #/Project
end #/Scrivener
