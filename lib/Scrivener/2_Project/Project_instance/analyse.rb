class Scrivener
class Project

  # Analyse du projet
  #
  # +paths+ est un Array des fichiers de texte de chaque
  # binder-item, simplifié (sans style, etc.)
  def analyse paths = nil
    @analyse ||= begin
      TextAnalyzer::Analyse.new(folder: folder, paths: paths, title: title, modified_at: modified_at)
    end
  end

  # On récupère les données d'analyse
  # Soit on les prend des fichiers déjà produits et enregistrés s'ils
  # existent, soient on calcule tout.
  def get_data_analyse
    CLI.debug_entry
    if analyse.exist? && analyse.uptodate? && !CLI.options[:force]
      # debug('L’analyse existe et elle est actualisée, je la recharge.')
      @analyse = TextAnalyzer::Analyse.reload(analyse)
      CLI.options[:force_calcul] && analyse.force_recalcul
    else
      debug(motif_reexec_analyse)
      analyse.exec(all_paths_simple_text)
    end
    return true # pour pouvoir continuer
  ensure
    CLI.debug_exit
  end

  # Développement seulement
  def motif_reexec_analyse
    if !analyse.exist?
      'L’analyse n’existe pas'
    elsif !analyse.uptodate?
      'L’analyse existe mais doit être actualisée'
    elsif CLI.options[:force]
      'Il faut forcer l’analyse'
    else
      'Pour une raison inconnue'
    end + ', je procède donc à l’analyse complète du texte.'
  end

  # Retourne la liste de tous les fichiers simple texte tirés
  # du projet Scrivener analysé.
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
