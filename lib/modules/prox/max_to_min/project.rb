=begin

  Module principal pour traiter les documents (binder-items) du plus
  dense au moins dense (en proximités)

=end
class Scrivener
class Project

  # = main =
  #
  # Méthode principale appelée par `scriv prox --maxtomin`
  #
  def exec_max_to_min
    Scrivener.require_module('lib/proximites')
    # Faire la liste de toutes les proximités
    get_data_analyse || return
    # Définir densités de chaque binder-items
    define_binder_items_densites
    # Classer les binder-items par densités (si nécessaire)
    sort_binder_items_by_densites
    # Juste pour les voir (options ?)
    if CLI.options[:tableau]
      display_binder_items_by_densites
    else
      Scrivener.require_module('prox/one_doc')
    end
  end

  # Afficher dans l'ordre la liste des binder-items par densité
  ENTETE_BINDER_ITEM_LISTE_DENSITE = '
| N°   | %s | %s | %s/%s |    ‰   |   Offset   | %s

  ' % [t('proximity.abbr.tit'), t('length.tit.sing'), t('length.abbr.tit'), t('proximity.abbr.min'), t('title.tit.sing')]

  LINE_BINDER_ITEM_DENSITE = '| %{findex} | %{nombre_proximites} | %{flength}  |  %{frapport}  | %{pour_mille}‰ |  %{foffset_start}  | %{ftitle}'
  def display_binder_items_by_densites
    # Pour conserver la longueur de la plus longue ligne
    # (pour les lignes horizontales)
    max_len_line = 0

    lines = Array.new
    lines << '-'
    lines << ENTETE_BINDER_ITEM_LISTE_DENSITE.strip
    lines << '-'

    liste = self.analyse.table_resultats.sorted_binder_items
    CLI.options[:mintomax] && liste = liste.reverse
    liste.each do |uuid|
      # TODO
      raise "CODE TO IMPLEMENT"
      bi_data = self.tablooo_proximites[:binder_items][uuid]
      bi_data[:densite] || next

      ftitle = if bi_data[:title].length > 70
        bi_data[:title][0...70] + ' […]'
      else
        bi_data[:title]
      end

      bi_line = LINE_BINDER_ITEM_DENSITE % bi_data.merge(
        nombre_proximites: bi_data[:proximites_count].to_s.rjust(5),
        flength:    bi_data[:length].to_s.rjust(8),
        foffset_start:  bi_data[:offset_start].to_s.rjust(8),
        pour_mille: bi_data[:densite].to_s.rjust(5),
        ftitle:     ftitle,
        findex:     bi_data[:index].to_s.ljust(4),
        frapport:   bi_data[:length_by_prox].to_s.rjust(7)
      )
      if bi_line.length > max_len_line
        max_len_line = bi_line.length
      end
      lines << bi_line
    end
    lines << '-'

    line_horizontale = '-' * (max_len_line + 1)
    lines[0] = line_horizontale
    lines[2] = line_horizontale
    lines[-1] = line_horizontale
    puts String::RC*2
    puts lines.join(String::RC)
    puts String::RC*2
  end
  # /display_binder_items_by_densites

  # Classer la liste des binder-items pour densité
  #
  # Cette méthode produit une liste Array contenant les UUID des binder-items,
  # du plus dense au moins dense. Cette liste est ajoutée à la table générale
  # des proximités et enregistrée.
  #
  def sort_binder_items_by_densites
    CLI.debug_entry
    if CLI.options[:force_calcul] || self.tabloo_proximites[:sorted_binder_items].nil?
      tbl = self.tablooo_proximites[:binder_items]
      liste_classed = tbl.sort_by { |bi_id, bi_data| bi_data[:length_by_prox] || 0 }.reverse.collect{|bid,did|bid}
      self.tablooo_proximites.merge!(sorted_binder_items: liste_classed)
      save_proximites
    end
    CLI.debug_exit
  end
  # /sort_binder_items_by_densites

  # Définir, au besoin, les densités des binder-items, ainsi que les
  # proximités (ID) qu'ils contiennent.
  def define_binder_items_densites
    CLI.debug_entry
    CLI.options[:force] || CLI.options[:force_calcul] || densite_binder_item_undefined? || return

    tbl = self.tablooo_proximites[:binder_items]
    densite_max = 0
    self.analyse.table_resultats.proximites.each do |prox_id, iprox|
      bmot = iprox.mot_avant
      if tbl[bmot.binder_item_uuid][:proximites].nil?
        tbl[bmot.binder_item_uuid].merge!(
          proximites: Array.new,
          proximites_count: 0,  # nombre de proximité
          densite:          nil # la densité
        )
      end
      tbl[bmot.binder_item_uuid][:proximites] << prox_id
      tbl[bmot.binder_item_uuid][:proximites_count] += 1
      if tbl[bmot.binder_item_uuid][:proximites_count] > densite_max
        densite_max = tbl[bmot.binder_item_uuid][:proximites_count]
      end
    end

    # On peut vraiment calculer la densité. Cette densité correspond au
    # nombre total de proximités par rapport au nombre dans le binder-item.
    nombre_total_proximites = self.analyse.table_resultats.proximites.count.to_f
    self.tablooo_proximites[:binder_items].each do |bi_uuid, bi_data|
      bi_data[:proximites_count] || next
      bi_data[:densite] = (1000 * (bi_data[:proximites_count] / nombre_total_proximites).round(4)).round(2)
      bi_data[:length_by_prox] = (bi_data[:length].to_f/bi_data[:proximites_count]).round(1)
    end
    # /fin de boucle sur les binder-items pour définir la densité

    # On enregistre à nouveau la table des proximités
    save_proximites

    CLI.dbg("<- Scrivener::Project#define_binder_items_densites (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
  end
  # /define_binder_items_densites

  # Retourne true si les densités des binder-items ne sont pas définies
  def densite_binder_item_undefined?
    self.tablooo_proximites[:binder_items].values.first[:proximites].nil?
  end
  # /densite_binder_item_undefined?

end #/Project
end #/Scrivener
