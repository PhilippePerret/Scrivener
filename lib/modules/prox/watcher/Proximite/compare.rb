class Proximite

  class << self

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
    # une table par défaut, avec des éléments vide.
    #
    def compare_tables new_table, old_table
      CLI.dbg("-> Scrivener::Project#compare_tables (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")

      # CLI.dbg(String::RC + '--- new_table:'+String::RC + new_table.to_yaml)
      # CLI.dbg(String::RC + '--- old_table:'+String::RC + old_table.to_yaml)

      project.tables_comparaison = Proximite::TableComparaison.new(new_table, old_table)
      project.tables_comparaison.compare_tables

      # Retourner les messages de modifications
      CLI.dbg("<--- Scrivener::Project#compare_tables (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
    rescue Exception => e
      raise_by_mode(e, Scrivener.mode)
    end
    # /compare_tables

  end #/<<self
end #/Proximite
