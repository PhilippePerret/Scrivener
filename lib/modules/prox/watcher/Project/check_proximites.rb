class Scrivener
class Project

  attr_accessor :last_tableau
  attr_accessor :tables_comparaison

  def check_etat_proximites_et_affiche_differences
    CLI.debug_entry

    # Écrit un message d'attente à l'écran
    write_log('* check…', :gris_clair, true)
    # p "*** Je vais check proximités in watched binder items"
    # sleep 1
    check_proximites_in_watched_binder_items
    # puts " - OK"

    # On peut procéder à la comparaison (si un ancien tableau existe)
    # p "*** Je vais comparer les tables"
    # sleep 1
    compare_tables_resultats(analyse.table_resultats, load_table_resultats_if_exist)
    # puts " - OK"

    # On sauve la nouvelle table de résultats
    save_new_table_resultats(analyse.table_resultats)

    # Affichage à l'écran de l'état des proximités
    output_tableau_etat()
    tables_comparaison.display_changes_in(winlog)

  rescue Exception => e
    raise_by_mode(e, Scrivener.mode)
  ensure
    CLI.debug_exit
  end
  # /check_etat_proximites_et_affiche_differences


  def save_new_table_resultats tableres
    File.open(last_table_resultats_path,'wb'){|f| Marshal.dump(tableres, f)}
  end
  # Retourne soit le dernier tableau d'analyse des proximités s'il existe
  # et s'il correspond au document analysés, ou un tableau par défaut, vide
  def load_table_resultats_if_exist
    if File.exists?(last_table_resultats_path)
      File.open(last_table_resultats_path,'rb'){|f| Marshal.load(f)}
    end
  end
  def table_par_default
    @table_par_default ||= {mots: Hash.new, proximites: Hash.new}
  end
  def last_table_resultats_path
    @last_table_resultats_path ||= File.join(hidden_folder, 'last_tableau_prox.msh')
  end
end #/Project
end #/Scrivener
