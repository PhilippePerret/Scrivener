# encoding: UTF-8
=begin

  Module contenant toutes les méthodes qui permettent de définir les données
  du projet Scrivener courant, que ce soit le titre, les zooms de l'interface
  ou le format de sortie de la compilation.

=end
require_relative '../setters_before'
  # Contient notamment la méthode self.add_settable_property

class Scrivener
class Project

  # ---------------------------------------------------------------------
  # Méthodes de modification des données

  # Définir le nom de fichier du projet
  add_settable_property(:name, {not_in_yam_file: true})
  def set_name value
    value === nil && return # quand un fichier de configuration met à null la valeur
    new_nom = value.gsub(/ /, '_')
    new_nom.end_with?('.scriv') || new_nom.concat('.scriv')
    if yesOrNo(t('projects.questions.set_title', {old_fn: File.basename(path).inspect, new_fn: new_nom.inspect}))
      old_path_scrivx = self.xfile.path
      new_path_scrivx = File.join(path, "#{new_nom}x")
      FileUtils.move(old_path_scrivx, new_path_scrivx)
      new_path = File.join(folder, new_nom)
      FileUtils.move(path, new_path)
      @path   = new_path
      @xfile  = nil
      # Attention il faut le passer en fichier courant (noter que ça retire
      # automatiquement l'ancien nom, qui n'existe plus)
      Scrivener.project_path = new_path
      Scrivener.save_current_informations
      Scrivener.save_last_projects_data
      confirme(:name, new_nom.inspect)
    end
  end

  # Définir le titre du projet
  # add_settable_property(:title)
  # TODO On devrait pouvoir définir le titre d'un document de cette manière
  # aussi, avec l'option '-doc="début du titre actuel"'
  def set_title value
    value === nil && return
    compile_xml.set_xpath('//MetaData/ProjectTitle', value)
    confirme(:title, value)
  end

  # Définir le titre abbrégé (court) du projet
  # add_settable_property(:title_abbreviated)
  def set_title_abbreviated value
    value === nil && return
    compile_xml.set_xpath('//MetaData/ProjectAbbreviatedTitle', value)
    confirme(:title_abbreviated, value)
  end


  # Définir l'auteur du projet
  # Note : chaque setter doit définir cette valeur pour tenir à jour la
  # table des matières.
  # Trois façons de le définir avec +value+ :
  #   - "Prénom Nom"
  #   - "Nom, Prénom"
  #   - {firstname: "Prénom", lastname: "Nom"}
  # add_settable_property(:author)
  def set_author value
    value === nil && return
    case value
    when String
      if value.index(',')
        value = value.split(',')
        prenom = value[1].strip
        patron = value[0].strip
      else
        value = value.split(' ')
        prenom = value.shift.strip
        patron = value.join(' ').strip
      end
    when Hash
      prenom = value[:firstname]
      patron = value[:lastname]
    end
    value_init = '%s %s' % [prenom, patron]
    define_author({firstname: prenom, lastname: patron})
    # Voir si cet auteur est déjà dans la liste
    # dans le cas contraire, l'ajouter (à la fin, pour le moment).
    author_found = false
    get_authors.each do |hau|
      if hau[:firstname] == prenom && hau[:lastname] == patron
        author_found = true
        break
      end
    end
    author_found || add_an_author({tag: 'Author', text: value_init, attrs: {Role: 'aut', FileAs: ('%s, %s' % [patron, prenom])}})
    confirme(:author, value_init)
  end

  # Définir les auteurs du projet
  # add_settable_property(:authors)
  def set_authors value
    value === nil && return
    compile_xml.remove_children_of_xpath('//MetaData/Authors')
    value.split(',').collect{|a| a.strip}.each do |patro|
      patro_init = patro
      patro = patro.split
      prenom = patro.shift
      patro = patro.join(' ')
      add_an_author({tag: 'Author', text: patro_init, attrs: {Role: 'aut', FileAs: ('%s, %s' % [patro, prenom])}})
    end
    confirme(:authors, value)
  end

  def add_an_author dauteur
    compile_xml.add_xpath('//MetaData/Authors', dauteur)
  end

  # ---------------------------------------------------------------------
  #   MÉTHODES INTERFACE

  # Définir la visibilité du classeur
  # add_settable_property(:binder_visible)
  def set_binder_visible value
    value === nil && return
    value = yes_or_no_value(value)
    project.ui_common.binder.visibility(value == 'Yes')
    confirme(:binder_visible, value.inspect)
  end

  # add_settable_property(:collections_visible)
  def set_collections_visible value
    value === nil && return
    value = yes_or_no_value(value)
    project.ui_common.collections_visibility(value == 'Yes')
    confirme(:collections_visible, value.inspect)
  end

  # ---------------------------------------------------------------------
  #   MÉTHODES INTERFACE ÉDITEURS

  # add_settable_property(:editors_header)
  def set_editors_header value
    value === nil && return
    value = yes_or_no_value(value)
    project.ui_common.editor1.header_visible(value == 'Yes')
    project.ui_common.editor2.header_visible(value == 'Yes')
    confirme(:editors_header, value.inspect)
  end

  # add_settable_property(:editors_footer)
  def set_editors_footer value
    value === nil && return
    value = yes_or_no_value(value)
    project.ui_common.editor1.footer_visible(value == 'Yes')
    project.ui_common.editor2.footer_visible(value == 'Yes')
    confirme(:editors_footer, value.inspect)
  end

  # add_settable_property(:editors_selection)
  def set_editor1_selection value
    set_editor_selection(1, value)
  end
  def set_editor2_selection value
    set_editor_selection(2, value)
  end
  def set_editor_selection index_editor, value
    value === nil && return
    paire = value.split(',').collect{|e| e.strip.to_i}
    project.ui.send("editor#{index_editor}".to_sym).text_selection = paire
    confirme(:editors_selection, [index_editor, paire.inspect])
  end

  # add_settable_property(:editor_view_mode)
  def set_editor_view_mode value
    value === nil && return
    value = real_value_in(value.capitalize, Project.modifiable_properties['values_mode_view']) || return
    project.ui_common.editor1.current_view_mode= value
    confirme(:editor_view_mode, value.inspect)
  end

  # add_settable_property( :editors_group_view_mode)
  def set_editor1_group_view_mode value
    set_editor_group_view_mode(1, value)
  end
  def set_editor2_group_view_mode value
    set_editor_group_view_mode(2, value)
  end
  def set_editor_group_view_mode index_editor, value
    value === nil && return
    value = real_value_in(value.capitalize, Project.modifiable_properties['values_mode_view']) || return
    project.ui_common.send("editor#{index_editor}".to_sym).group_view_mode= value
    confirme(:editors_group_view_mode, [index_editor, value.inspect])
  end

  # ---------------------------------------------------------------------
  #   MÉTHODES INTERFACE INSPECTEUR

  # add_settable_property(:inspector_visible)
  def set_inspector_visible value
    value === nil && return
    value = yes_or_no_value(value)
    project.ui_common.inspector.visibility(value == 'Yes')
    confirme(:inspector_visible, value.inspect)
  end

  # add_settable_property(:inspector_tab)
  def set_inspector_tab value
    value === nil && return
    UI::UICommon::Inspector::ONGLETS[value.downcase.to_sym] || raise(ERRORS[:bad_onglet_inspector])
    project.ui_common.inspector.set_onglet(value)
    confirme(:inspector_tab, value.inspect)
  end

  # Définir le zoom des notes
  # add_settable_property(:zoom_notes)
  def set_zoom_notes value
    value === nil && return
    factor = any_value_as_factor(value)
    project.ui.notes_scale_factor= factor
    confirme(:zoom_notes, "#{(factor * 100).round}%")
  end

  # Définir le zoom de l'éditeur principal
  # add_settable_property(:zoom_editor)
  def set_zoom_editor value
    value === nil && return
    factor = any_value_as_factor(value)
    project.ui.main_document_editor.text_scale_factor= factor
    confirme(:zoom_editor, "#{(factor * 100).round}%")
  end

  # Définir le zoom de l'éditeur secondaire
  # add_settable_property(:zoom_alt_editor)
  def set_zoom_alt_editor value
    value === nil && return
    factor = any_value_as_factor(value)
    project.ui.supporting_document_editor.text_scale_factor= factor
    confirme(:zoom_alt_editor, "#{(factor * 100).round}%")
  end

  # add_settable_property(:zoom_editors)
  def set_zoom_editors value
    value === nil && return
    set_zoom_editor value
    set_zoom_alt_editor value
  end

  # add_settable_property(:compile_comments)
  def set_compile_comments value
    value === nil && return
    value = yes_or_no_value(value) == 'Yes' ? 'No' : 'Yes'
    compile_xml.remove_comments= value
    confirme(:compile_comments, value)
  end

  # add_settable_property(:compile_annotations)
  def set_compile_annotations value
    value === nil && return
    value = yes_or_no_value(value) == 'Yes' ? 'No' : 'Yes'
    compile_xml.remove_annotations = value
    confirme(:compile_annotations, value)
  end


  # add_settable_property(:compile_output)
  def set_compile_output value
    value === nil && return
    # Value doit être 'print' ou 'pdf'
    dvalue = XMLCompile::OUTPUT_FORMATS[value.downcase.to_sym] || rt('errors.only_values', {var: 'compile_output', values: t('notices.ask_for_compile_help')})
    compile_xml.set_xpath('//CurrentFileType', dvalue[:value])
    confirme(:compile_output, dvalue[:hname])
  end

  # add_settable_property(:target)
  # TODO On doit aussi pouvoir définir --notify, --show_overrun et --show_buffer
  #      et les autres options pour un projet
  # TODO Pouvoir mettre :options à # add_settable_property pour afficher les options des
  #      différentes commandes
  # +value+ peut venir de la ligne de commande ou d'un fichier YAML. Dans
  # un fichier YAML, on trouver "<nom document (début)>::<longueur avec unité>"
  def set_objectif value
    if value.match(/::/)
      CLI.options[:document], what = value.split('::')
    else
      what = CLI.options[:document] || :projet
    end
    final_value = human_value_objectif_to_real_value(value)
    if what == :projet
      # Objectif du projet
      if yesOrNo('Voulez-vous régler l’objectif général du projet à %i signes ?' % [final_value])
        # CountIncludedOnly=Yes/No, CurrentCompileGroupOnly=Yes/no, Deadline=<time>, IgnoreDeadline=Yes/no
        hd = {type: 'Characters', nombre: final_value}
        CLI.options.key?(:current_compile_group_only) && hd.merge!(current_compile_group_only: CLI.options[:current_compile_group_only])
        CLI.options.key?(:count_included_only) && hd.merge!(count_included_only: CLI.options[:count_included_only])
        CLI.options.key?(:deadline) && hd.merge!(deadline: CLI.options[:deadline])
        CLI.options.key?(:ignore_deadline) && hd.merge!(ignore_deadline: CLI.options[:ignore_deadline])
        project.xfile.objectif= hd
      else
        return
      end
    else
      # Objectif du document
      bitem = binder_item_by_title(what, raise: true)
      if yesOrNo('Voulez-vous définir l’objectif de « %s » à %i signes ?' % [bitem.title, final_value])
        bitem.target.define(final_value, {type: 'Characters', notify: false, show_overrun: true, show_buffer: true})
      else
        return
      end
    end
    confirme(:objectif, [what == :projet ? 'projet' : ('document %s ' % [bitem.title]), final_value])
  end


  # add_settable_property(:targets)
  def set_targets value
    value.is_a?(Array) || raise('Il faut une liste, pour définir les objectifs de documents')
    value.each do |docdef|
      docdef = docdef.split('::')
      len = human_value_objectif_to_real_value(docdef.pop, true)
      tit = docdef.join('::')
      bitem = binder_item_by_title(tit, raise: true)
      bitem.target.define(len, {type: 'Characters', notify: false, show_overrun: true, show_buffer: true})
    end
  end


end #/Project
end #/Scrivener
