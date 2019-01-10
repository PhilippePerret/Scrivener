class Scrivener
class Project
class TableComparaison

  TEMP_ADDED_PROX = '  ADDED: %s [%i in « %s »] <-> %s [%i in %s]' + String::RC
  TEMP_FIXED_PROX = '  FIXED: %s [%i in « %s »] <-> %s [%i in %s]' + String::RC


  attr_accessor :new_table, :old_table
  # Comme instances Proximite::Table
  attr_accessor :ntable, :otable

  # instanciation d'une nouvelle comparaison de table
  #
  # param +new_table+   Table de proximités (Hash) qui correspond
  #                     à Project#tableau_proximite
  # param +old_table+   Idem, mais c'est la dernière enregistrée ou une table
  #                     par défaut.
  #
  def initialize new_table, old_table
    self.new_table = new_table
    self.old_table = old_table
    # On fait deux instances de Proximite::Table
    self.ntable = TableComparaison::Table.new(new_table)
    self.otable = TableComparaison::Table.new(old_table)
  end

  # Méthode de comparaison des deux tables
  def compare_tables
    ntable.compare_with_table(otable)
    otable.compare_with_table(ntable)
  end

  # Nouvelles proximités trouvées (donc erreur ajoutée)
  #
  # Note : elles correspondent aux proximités propres de la nouvelle table
  def added_proximites
    @added_proximites ||= ntable.proximites_propres
  end

  # Anciennes proximités corrigées
  #
  # Ce sont les proximités qu'on trouve dans la vieille table et qui ne
  # se trouvent plus dans la nouvelle.
  def fixed_proximites
    @fixed_proximites ||= otable.proximites_propres
  end

  # ---------------------------------------------------------------------
  #   HELPERS
  #

  # Pour afficher les changements dans la fenêtre +wnd+ qui doit être
  # une Curses::Console::Window (donc mes instances)
  #
  def display_changes_in wnd
    wnd.clear
    if added_proximites.empty? && fixed_proximites.empty?
      wnd.affiche(@any_changement ||= (' -- %s --' % [t('notices.any_change')]))
    else
      added_proximites.each do |iprox|
        pmot = iprox.mot_avant
        nmot = iprox.mot_apres
        wnd.affiche(TEMP_ADDED_PROX % [
          pmot.real,
          pmot.relative_offset,
          pmot.binder_item.title,
          nmot.real,
          nmot.relative_offset,
          nmot.binder_item.title == pmot.binder_item.title ? 'idem' : "« #{nmot.binder_item.title} »"
          ], {style: :other_red})
      end
      fixed_proximites.each do |iprox|
        pmot = iprox.mot_avant
        nmot = iprox.mot_apres
        wnd.affiche(TEMP_FIXED_PROX % [
          pmot.real,
          pmot.relative_offset,
          pmot.binder_item.title,
          nmot.real,
          nmot.relative_offset,
          nmot.binder_item.title == pmot.binder_item.title ? 'idem' : "« #{nmot.binder_item.title} »"
          ], {style: :vert})
      end
    end
    wnd.refresh
  end

end #/TableComparaison
end #/Project
end #/Scrivener
