# encoding: UTF-8
=begin

=end
class Scrivener
class Project
class BinderItem

  attr_accessor :elements

  # Mais peut-être qu'il faudrait remplacer par :target
  attr_accessor :objectif

  # Pour le moment, on ne prend que les éléments sans enfants
  def treate_as_tdm_item(tdm, conteneur)
    # Si l'élément ne doit pas être inclus dans le manuscrit, on
    # le passe.
    self.compiled? || return

    # Soit le binder item possède une size, soit on lui donne une
    # taille de zéro
    self.size ||= SWP.new(0)

    # On lui définit un objectif en fonction de celui défini
    self.objectif = SWP.new(self.target.signes || 0)

    # On met l'élément dans son conteneur
    conteneur.elements << self

    if parent?
      # <= Il a des enfants
      # => On doit traiter ses enfants
      self.elements = Array.new
      children.each do |child|
        child.treate_as_tdm_item(tdm, self)
      end
    end

    # On ajoute au conteneur la taille et la cible
    conteneur.size     += self.size
    conteneur.objectif += self.objectif

  end
  #/treate_as_tdm_item

  # Construit le titre formaté, en fonction de l'identantion, en
  # définit la longueur max pour un titre si ce titre est le plus
  # long actuellement
  # +tdm+ Instance {Scrivener::Project::TDM} de la table des matières pour
  #       laquelle le titre est formaté
  def build_formated_title tdm, identation = 1
    mots_et_signes = if tdm.options[:with_numbers]
      target.mots ? (' [%i c. ≃ %i m. ≃ %s p.]' % [target.signes, target.mots, target.pages]) : ''
    else '' end
    @formated_title = '%s%s%s ' % [(TDM::TITLE_IDENTATION * identation), title, mots_et_signes]
    if formated_title.length > tdm.title_width
      tdm.title_width = formated_title.length
    end
    if parent?
      children.each do |child|
        child.build_formated_title(tdm, identation + 1)
      end
    end
  end
  # Le titre formaté, c'est-à-dire avec l'identation (mais pas les
  # points qui vont rejoindre le numéro)
  def formated_title ; @formated_title end

  # Construit la ligne de table des matières
  #
  # C'est la méthode principale qui construit la ligne de table des matières
  # du binder-item (et de ses enfants).
  #
  # +pdata+ C'est la table principale et générale contenant toutes les
  #         informations.
  def add_ligne_pagination(tdm, identation = 1)
    str_indent      = '  ' * identation
    formated_title_line = "#{formated_title} ".ljust(tdm.title_width + 5, '.')
    fpage_by_obj =

    line = template_line % {
      ftitle:         formated_title_line,
      fpage_by_wri:   (' '+tdm.current_size.page.to_s).rjust(tdm.wri_page_number_width + 1,'.'),
      fpage_by_obj:   formated_page_by_objectif(tdm),
      fsigns:         formated_signs(tdm.wri_chars_count_width),
      fobjectif:      formated_objectif(tdm.obj_chars_count_width),
      fstate:         formated_state,
      fdiff:          formated_diff,
      fpages:         formated_pages_real(8),
      fcumul_pages:   tdm.current_size.pages_real_round.to_s.rjust(10)
    }

    self.text? || line = line.gris

    tdm.lines << line

    parent? && begin
      children.each do |sitem|
        sitem.add_ligne_pagination(tdm, identation + 1)
      end
    end

    self.text? || return

    # Si le binder-item contient du texte, on ajoute sa taille au
    # nombre de signes courants
    tdm.current_size      += self.size
    tdm.current_objectif  += self.objectif

  end

  def formated_state
    @formated_state ||= begin
      if objectif > 0
        '*'.send(color_obj_reached) + '*'.send(color_obj_too_big)
      else
        ''.ljust(2)
      end
    end
  end
  # /formated_state

  def formated_diff
    @formated_diff ||= begin

    end
  end
  # /formated_diff

  def color_obj_reached
    @color_obj_reached ||= diff_wri_obj > 0 ? :vert : :rouge
  end
  def color_obj_too_big
    @color_obj_too_big ||= diff_too_big? ? :rouge : :vert
  end

  def diff_too_big?
    @diff_wri_obj_is_too_big ||= begin
      diff_wri_obj.abs > (objectif.signs / 12)
    end
  end
  # Différence (positive ou négative) entre ce qui est écrit et ce qui
  # doit l'être
  def diff_wri_obj
    @diff_wri_obj ||= begin
      if objectif > 0
        size.signs - objectif.signs
      else
        nil
      end
    end
  end

  def formated_signs(len)
    @formated_signs ||= (size.signs > 0 ? size.signs : '-').to_s.rjust(len)
  end
  def formated_pages_real(len)
    @formated_pages_real ||= (size.pages_real_round > 0 ? size.pages_real_round : '-').to_s.rjust(len)
  end
  def formated_objectif(len)
    @formated_objectif ||= begin
      if objectif.signs > 0
        objectif.signs.to_s
      else
        '-'
      end.ljust(len)
    end
  end
  def formated_page_by_objectif(tdm)
    tdm.current_objectif.page.to_s.rjust(tdm.obj_page_number_width + 1)
  end

end #/BinderItem
end #/Project
end #/Scrivener
