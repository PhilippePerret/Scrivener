class Scrivener
class Project

  # = main =
  #
  # Méthode de classe qui compare deux tables de proximité
  #
  # Pour procéder à la comparaison, on utilise :
  #   - deux instances Proximite::Table pour l'ancienne table et la nouvelle
  #   - une instance Proximite::TablesComparaison qui permettra de rassembler
  #     les opérations et construire les messages.
  #
  # Note : la première fois qu'un document est surveillé, +old_table+ est
  # nil
  #
  def compare_tables_resultats new_table, old_table
    CLI.debug_entry
    old_table != nil || return
    tables_comparaison = TableComparaison.new(new_table, old_table)
    tables_comparaison.compare_tables
  rescue Exception => e
    raise_by_mode(e, Scrivener.mode)
  ensure
    CLI.debug_exit
  end
  # /compare_tables

end #/Project
end #/Scrivener
