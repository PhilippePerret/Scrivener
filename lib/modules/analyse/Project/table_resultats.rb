class Scrivener
class Project

  # On récupère les données de proximités
  # Soit on les prend des fichiers déjà produits et enregistrés s'ils
  # existent, soient on calcule tout.
  def get_data_analyse
    CLI.debug_entry
    if analyse.exist? && !CLI.options[:force]
      analyse.reload
      CLI.options[:force_calcul] && analyse.force_recalcul
    else
      analyse.exec(all_paths_simple_text)
    end
    CLI.debug_exit
    return true # pour pouvoir continuer
  end

  def all_paths_simple_text
    # On procède à la relève
    dargs = {only_text: true, deep: true}
    all_binder_items_of(xfile.draftfolder, dargs).collect do |bitem|
      bitem.build_simple_text_file || next
      bitem.simple_text_path
    end.compact
  end
end #/Project
end #/Scrivener
