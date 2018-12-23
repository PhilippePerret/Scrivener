# encoding: UTF-8
=begin

=end
class Scrivener
class Project
class BinderItem
  # Main méthode qui traite le noeud
  #
  # Pour le moment, on ne prend que les éléments sans enfants
  def treate_objectif(tableau)
    self.compiled? || (return tableau)
    data = {
      binder_item:  self,
      title:        title,
      objectif:     objectif,
      elements:     Array.new,
      size:         self.size
    }
    # On met l'élément dans le tableau
    tableau[:elements] << data
    if parent?
      # <= Il a des enfants
      # => On doit traiter ses enfants
      nombre = 0
      children.each do |child|
        child.treate_objectif(tableau[:elements].last)
        child.objectif && nombre += child.objectif
      end
      @objectif ||= nombre
      tableau[:elements].last[:objectif] = self.objectif
    else
      tableau[:elements].last.delete(:elements)
    end
  end
  #/treate_objectif

  # Construit le titre formaté, en fonction de l'identantion, en
  # définit la longueur max pour un titre si ce titre est le plus
  # long actuellement
  def build_formated_title identation = 1
    mots_et_signes = if project.options[:with_nombres]
      target.mots ? (' [%i c. ≃ %i m. ≃ %s p.]' % [target.signes, target.mots, target.pages]) : ''
    else '' end
    @formated_title = '%s%s%s ' % [(TITLE_IDENTATION * identation), title, mots_et_signes]
    if formated_title.length > project.title_max_length
      project.title_max_length = formated_title.length
    end
    if parent?
      children.each do |child|
        child.build_formated_title(identation + 1)
      end
    end
  end
  # Le titre formaté, c'est-à-dire avec l'identation (mais pas les
  # points qui vont rejoindre le numéro)
  def formated_title ; @formated_title end

  # Ajoute à +ligne+ la ligne de mise en forme de l'élément, en traitant
  # aussi ses enfants.
  # C'est la méthode principale qui construit la ligne de table des matières
  # du binder-item (et de ses enfants).
  #
  # +pdata+ C'est la table principale et générale contenant toutes les
  #         informations.
  def add_ligne_pagination(pdata, identation = 1)
    nombre_signes_init  = 0 + pdata[:current_nombre_signes]
    nombre_signes_after = nombre_signes_init + objectif.to_i
    pagination      = (nombre_signes_init.to_f / NOMBRE_SIGNES_PER_PAGE).floor + 1
    str_indent      = '  ' * identation
    substr_indent   = '' #'  ' * (4 - identation)
    title_length    = 60 - str_indent.length
    formated_title_line = "#{formated_title} ".ljust(project.title_max_length + 5, '.')
    formated_page   = substr_indent + pagination.to_s.rjust(project.page_number_width + 1)
    pdata[:tdm] << '  %s%s' % [formated_title_line, formated_page]
    parent? && begin
      children.each do |sitem|
        sitem.add_ligne_pagination(pdata, identation + 1)
      end
    end
    pdata[:current_nombre_signes] = nombre_signes_after
  end

end #/BinderItem
end #/Project
end #/Scrivener
