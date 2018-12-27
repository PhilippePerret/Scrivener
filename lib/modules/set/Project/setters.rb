# encoding: UTF-8
=begin

  Module contenant toutes les méthodes qui permettent de définir les données
  du projet Scrivener courant, que ce soit le titre, les zooms de l'interface
  ou le format de sortie de la compilation.

  NOTE
  Ce module est aussi chargé par getter.rb pour pouvoir connaitre la liste
  des propriétés MODIFIABLE_PROPERTIES.

=end
class Scrivener
class Project

  TABLE_EQUIVALENCE_DATA_SET = {
    auteur:                       :author,
    auteurs:                      :authors,
    classeur_visible:             :binder_visible,
    compiler_sans_commentaires:   :remove_comments_on_compile,
    compiler_sans_annotations:    :remove_annotations_on_compile,
    entete_editeurs:              :editors_header,
    pied_de_page_editeurs:        :editors_footer,
    mode_vue_editeur1:            :editor1_view_mode,
    mode_vue_editeur2:            :editor2_view_mode,
    mode_vue_groupe_editeur1:     :editor1_group_view_mode,
    mode_vue_groupe_editeur2:     :editor2_group_view_mode,
    inspecteur_visible:           :inspector_visible,
    sortie_compilation:           :compile_output,
    titre:                        :title,
    titre_court:                  :title_abbreviate,
    zoom_editeurs:                :zoom_editors,
    zoom_editeur:                 :zoom_editor,
    zoom_autre_editeur:           :zoom_alt_editor
  }

  # Liste des méthodes, pour l'aide
  MODIFIABLE_PROPERTIES = Hash.new

  # Différents textes qu'on peut trouver pour différentes propriétés
  DIVEXPLI = {
    factor_or_pourcentage: 'On peut le définir soit par un facteur (zoom_editor=2.5) soit par un pourcentage (zoom_editor="150%").',
    yes_or_no_values: {'Yes' => [nil, 'Yes', 'yes', 'y', 'oui', 'o', 'true', 'vrai'], 'No' => ['n', 'No', 'non', 'false', 'faux']},
    modes_vues: {'Single' => ['Single', 'Texte', 'T'], 'Scrivenings' => ['Scrivenings', 'Textes', 'S'], 'Corkboard' => ['Corkboard', 'C'], 'Outliner' => ['Plan', 'Outliner', 'O']}
  }

  # ---------------------------------------------------------------------
  # Méthodes de modification des données

  # POUR FAIRE DES ESSAIS AVEC LA COMMANDE `scriv set essai`
  def set_essai value = nil
    # puts "La valeur de value est #{value.inspect}"
    # dproximites = project.binder_item('B6C40A17-4527-4481-9547-64252E551B0D')

    second_chapitre   = project.binder_item('76E56CA6-F25A-41E6-A513-44309432382F')
    premier_chapitre  = project.binder_item('0F81282D-A49B-43E4-8EDB-31E192CBF90A')
    chapitre_trois    = project.binder_item('8A0B3C46-465A-452B-992E-FF90FC4267F9')

    # # ui_common.binder.unselect_all
    # ui_common.save

    # puts '--' + ui_common.editor1.view_node.count.inspect
    # puts '-- view_node 12' + ui_common.editor1.view_node.elements['ShowHeader'].text.inspect

    # ui_common.editor1.header_visible(false)
    # ui_common.editor2.header_visible(true)
    # ui_common.editor1.footer_visible(true)
    # ui_common.editor2.footer_visible(false)
    # ui_common.save
    # puts 'Je rends l’header visible ou invisible'

    # puts '--- second_chapitre : %s::{%s}' % [second_chapitre.title, second_chapitre.class.to_s]
    # puts '--- premier_chapitre: %s::{%s}' % [premier_chapitre.title, premier_chapitre.class.to_s]
    # ui_common.editor1.content= chapitre_trois
    # # ui_common.editor1.content= [premier_chapitre, second_chapitre]
    # ui_common.editor2.content= second_chapitre

    # ui_common.editor1.reset_historique
    # ui_common.editor1.add_historique([premier_chapitre, second_chapitre, chapitre_trois], {last_is_current: true})
    ui_common.editor1.reset_historique
    ui_common.editor1.add_historique([chapitre_trois, second_chapitre, premier_chapitre], {last_is_current: true})

    ui_common.save
  end

  def self.add_modpro h
    MODIFIABLE_PROPERTIES.key?(h.keys.first) && raise('LA CLÉ %s existe déjà !' % [h.keys.first])
    MODIFIABLE_PROPERTIES.merge!(h)
  end

  # Définir l'auteur du projet
  # Note : chaque setter doit définir cette valeur pour tenir à jour la
  # table des matières.
  add_modpro(
    :author => {hname: 'auteur', variante: 'auteur', description: 'Pour définir le prénom et nom de l’auteur principal du projet.', exemple: "Alphonse Jouard".inspect,
      category: :project_infos, confirmation: 'Auteur principal mis à %s'}
  )
  # Trois façons de le définir avec +value+ :
  #   - "Prénom Nom"
  #   - "Nom, Prénom"
  #   - {firstname: "Prénom", lastname: "Nom"}
  def set_author value
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
    compile_xml.set_xpath('//MetaData/Surname', patron)
    compile_xml.set_xpath('//MetaData/Forename', prenom)
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
  add_modpro(
    :authors => {hname: 'auteurs', variante: 'auteurs', description: 'Pour définir les prénoms et noms de tous les auteurs du projet.', exemple: "John Ford, Fred Vargas".inspect,
      category: :project_infos, confirmation: 'Auteurs mis à %s'}
  )
  def set_authors value
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

  # Définir le titre du projet
  add_modpro(
    :title => {hname: 'titre', variante: 'titre', description: 'Pour définir le titre complet du projet.', exemple: "Titre complet du projet".inspect,
      category: :project_infos, confirmation: 'Titre mis à « %s »'}
  )
  # TODO On devrait pouvoir définir le titre d'un document de cette manière
  # aussi, avec l'option '-doc="début du titre actuel"'
  def set_title value
    compile_xml.set_xpath('//MetaData/ProjectTitle', value)
    confirme(:title, value)
  end

  # Définir le titre abbrégé (court) du projet
  add_modpro(
    :title_abbreviate => {hname: 'titre abrégé', variante: 'titre_court', description: 'Pour définir le titre court du projet.', exemple: "Tit. court".inspect,
      category: :project_infos, confirmation: 'Titre abrégé mis à « %s »'}
  )
  def set_title_abbreviate value
    compile_xml.set_xpath('//MetaData/ProjectAbbreviatedTitle', value)
    confirme(:title_abbreviate, value)
  end


  # ---------------------------------------------------------------------
  #   MÉTHODES INTERFACE

  # Définir la visibilité du classeur
  add_modpro(
    :binder_visible => {hname: 'Visibilité du classeur', variante: 'classeur_visible', description: 'Pour définir la visibilité du classeur.', exemple: 'Oui', values: DIVEXPLI[:yes_or_no_values],
      category: [:interface, :binder], confirmation: 'Visibilité du classeur mise à %s'}
  )
  def set_binder_visible value
    value = yes_or_no_value(value)
    project.ui_common.binder.visibility(value == 'Yes')
    confirme(:binder_visible, value.inspect)
  end

  add_modpro(
    :collections_visible => {hname: 'Visibilité des collections', variante: nil, description: 'Pour définir la visibilité des collections dans le classeur.', exemple: 'Y', values: DIVEXPLI[:yes_or_no_values],
      category: [:interface, :binder], confirmation: 'Visibilité des collections dans le classeur mise à %s'}
  )
  def set_collections_visible value
    value = yes_or_no_value(value)
    project.ui_common.collections_visibility(value == 'Yes')
    confirme(:collections_visible, value.inspect)
  end

  # ---------------------------------------------------------------------
  #   MÉTHODES INTERFACE ÉDITEURS

  add_modpro(
    :editors_header => {hname: 'Visibilité des entêtes des éditeurs', variante: 'entete_editeurs', description: 'Pour définir si les entêtes doivent être visibles dans les deux éditeurs.', exemple: 'Yes', values: DIVEXPLI[:yes_or_no_values],
      category: [:interface, :editors], confirmation: 'Visibilité des entêtes mise à %s'}
  )
  def set_editors_header value
    value = yes_or_no_value(value)
    project.ui_common.editor1.header_visible(value == 'Yes')
    project.ui_common.editor2.header_visible(value == 'Yes')
    confirme(:editors_header, value.inspect)
  end
  add_modpro(
    :editors_footer => {hname: 'Visibilité des pieds de page des éditeurs', variante: 'pied_de_page_editeurs', description: 'Pour définir si les pieds de page doivent être visibles dans les deux éditeurs.', exemple: 'Yes', values: DIVEXPLI[:yes_or_no_values],
      category: [:interface, :editors], confirmation: 'Visibilité des pieds de page mise à %s'}
  )
  def set_editors_footer value
    value = yes_or_no_value(value)
    project.ui_common.editor1.footer_visible(value == 'Yes')
    project.ui_common.editor2.footer_visible(value == 'Yes')
    confirme(:editors_footer, value.inspect)
  end

  add_modpro(
    :editor1_view_mode => {hname: 'Mode de vue de l’éditeur principal', variante: 'mode_vue_editeur1', description: 'Pour définir le mode d’affichage de l’éditeur principal, c’est-à-dire pour définir s’il doit afficher le ou les textes, le tableau d’affichage ou le plan.', exemple: 'Plan',
      values: DIVEXPLI[:modes_vues], category: [:interface, :editors], confirmation: 'Mode courant de vue de l’éditeur principal mis à %s'
    }
  )
  def set_editor1_view_mode value
    value = real_value_in(value.capitalize, DIVEXPLI[:modes_vues]) || return
    project.ui_common.editor1.current_view_mode= value
    confirme(:editor1_view_mode, value.inspect)
  end
  add_modpro(
    :editor2_view_mode => {hname: 'Mode de vue de l’éditeur secondaire', variante: 'mode_vue_editeur2', description: 'Pour définir le mode d’affichage de l’éditeur secondaire, c’est-à-dire pour définir s’il doit afficher le ou les textes, le tableau d’affichage ou le plan.', exemple: 'Corkboard',
      values: DIVEXPLI[:modes_vues], category: [:interface, :editors], confirmation: 'Mode courant de vue de l’éditeur secondaire mis à %s'
    }
  )
  def set_editor2_view_mode value
    value = real_value_in(value.capitalize, DIVEXPLI[:modes_vues]) || return
    project.ui_common.editor2.current_view_mode= value
    confirme(:editor2_view_mode, value.inspect)
  end


  add_modpro(
    :editor1_group_view_mode => {hname: 'Mode de vue de groupe dans l’éditeur principal', variante: 'mode_vue_groupe_editeur1', description: 'Pour définir le mode d’affichage d’un groupe de documents ou de dossier dans l’éditeur principal, c’est-à-dire pour définir s’il doit afficher les textes, le tableau d’affichage ou le plan.', exemple: 'Plan',
      values: DIVEXPLI[:modes_vues], category: [:interface, :editors], confirmation: 'Mode courant de vue de groupe de l’éditeur principal mis à %s'
    }
  )
  def set_editor1_group_view_mode value
    value = real_value_in(value.capitalize, DIVEXPLI[:modes_vues]) || return
    project.ui_common.editor1.group_view_mode= value
    confirme(:editor1_group_view_mode, value.inspect)
  end
  add_modpro(
    :editor2_group_view_mode => {hname: 'Mode de vue de groupe dans l’éditeur secondaire', variante: 'mode_vue_groupe_editeur2', description: 'Pour définir le mode d’affichage d’un groupe de documents ou de dossier de l’éditeur secondaire, c’est-à-dire pour définir s’il doit afficher les textes, le tableau d’affichage ou le plan.', exemple: 'Corkboard',
      values: DIVEXPLI[:modes_vues], category: [:interface, :editors], confirmation: 'Mode courant de vue de groupe de l’éditeur secondaire mis à %s'
    }
  )
  def set_editor2_group_view_mode value
    value = real_value_in(value.capitalize, DIVEXPLI[:modes_vues]) || return
    project.ui_common.editor2.group_view_mode= value
    confirme(:editor2_group_view_mode, value.inspect)
  end

  # ---------------------------------------------------------------------
  #   MÉTHODES INTERFACE INSPECTEUR

  add_modpro(
    :inspector_visible => {hname: 'Visibilité de l’inspecteur', variante: 'inspecteur_visible', description: 'Pour définir la visibilité de l’inspecteur.', exemple: 'No', values: DIVEXPLI[:yes_or_no_values],
      category: [:interface, :inspector], confirmation: 'Visibilité de l’inspecteur mise à %s'}
  )
  def set_inspector_visible value
    value = yes_or_no_value(value)
    project.ui_common.inspector.visibility(value == 'Yes')
    confirme(:inspector_visible, value.inspect)
  end

  INSPECTOR_ONGLETS = ['Notes', 'Bookmarks', 'MetaData', 'Snapshots', 'Comments']
  add_modpro(
    :inspector_onglet => {hname: 'Onglet de l’inspecteur', variante: 'inspecteur_onglet', description: 'Pour définir l’onglet courant de l’inspecteur.', exemple: 'Bookmarks', values: INSPECTOR_ONGLETS,
      category: [:interface, :inspector], confirmation: 'Onglet courant de l’inspecteur mis à %s'}
  )
  def set_inspector_onglet onglet
    INSPECTOR_ONGLETS.include?(onglet) || raise(ERRORS[:bad_onglet_inspector])
    project.ui_common.inspector.set_onglet(onglet)
    confirme(:inspector_onglet, value.inspect)
  end

  # Définir le zoom des notes
  add_modpro(
    :zoom_notes => {hname: 'zoom des notes', description: 'Pour définir la taille des notes dans l’inspecteur.', exemple: '1.5',
      category: [:interface, :inspector], confirmation: 'Zoom des notes dans l’inspecteur mis à %s'}
  )
  def set_zoom_notes value
    factor = any_value_as_factor(value)
    project.ui.notes_scale_factor= factor
    confirme(:zoom_notes, "#{(factor * 100).round}%")
  end

  # Définir le zoom de l'éditeur principal
  add_modpro(
    :zoom_editor => {hname: 'zoom de l’éditeur', variante: 'zoom_editeur', description: 'Pour définir le zoom dans l’éditeur. %s' % [DIVEXPLI[:factor_or_pourcentage]], exemple: "200%".inspect,
      category: :interface, confirmation: 'Zoom de l’éditeur principal mis à %s'}
  )
  def set_zoom_editor value
    factor = any_value_as_factor(value)
    project.ui.main_document_editor.text_scale_factor= factor
    confirme(:zoom_editor, "#{(factor * 100).round}%")
  end

  # Définir le zoom de l'éditeur secondaire
  add_modpro(
    :zoom_alt_editor => {hname: 'zoom de l’éditeur alternatif', variante: 'zoom_autre_editeur', description: 'Pour définir le zoom dans le second éditeur. %s' % [DIVEXPLI[:factor_or_pourcentage]], exemple: "2",
      category: :interface, confirmation: 'Zoom de l’éditeur alternatif mis à %s'}
  )
  def set_zoom_alt_editor value
    factor = any_value_as_factor(value)
    project.ui.supporting_document_editor.text_scale_factor= factor
    confirme(:zoom_alt_editor, "#{(factor * 100).round}%")
  end

  add_modpro(
    :zoom_editors => {hname: 'zoom des deux éditeurs', variante: 'zoom_editeurs', description: 'Pour définir le zoom dans les deux éditeurs en même temps. %s' % [DIVEXPLI[:factor_or_pourcentage]], exemple: "250".inspect,
      category: :interface}
  )
  def set_zoom_editors value
    set_zoom_editor value
    set_zoom_alt_editor value
  end

  add_modpro(
    :remove_comments_on_compile => {hname: 'Ne pas compiler les commentaires', variante: 'compiler_sans_commentaires', description: 'Pour compiler le projet sans ou avec les commentaires', exemple: 'vrai', values: DIVEXPLI[:yes_or_no_values],
      category: :compilation, confirmation: 'Suppression ou ajout des commentaires à la compilation mis à %s'}
  )
  def set_remove_comments_on_compile value
    value = yes_or_no_value(value)
    compile_xml.set_xpath('//Options/RemoveComments', value)
    confirme(:remove_comments_on_compile, value)
  end

  add_modpro(
    :remove_annotations_on_compile => {hname: 'Suppression des annotations à la compilation', variante: 'compiler_sans_annotations', description: 'Pour compiler le projet avec ou sans les annotations.', exemple: 'Oui', values: DIVEXPLI[:yes_or_no_values],
      category: :compilation, confirmation: 'suppression ou ajout des annotations à la compilation défini'}
  )
  # puts "DIVEXPLI[:yes_or_no_values]: #{DIVEXPLI[:yes_or_no_values].inspect}"
  def set_remove_annotations_on_compile value
    compile_xml.set_xpath('//Options/RemoveAnnotations', yes_or_no_value(value))
    confirme(:remove_annotations_on_compile)
  end


  add_modpro(
    :compile_output => {hname: 'Type de sortie de la compilation', variante: 'sortie_compilation', description: 'Pour définir s’il faut imprimer ou créer un document PDF lors de la compilation.', exemple: 'PDF', values: {'un document PDF' => ['pdf', 'PDF'], 'imprimer le projet' => ['print', 'PRINT', 'imprimer']},
      category: :compilation, confirmation: 'Format de sortie de compilation mis à %s'}
  )
  def set_compile_output value
    # Value doit être 'print' ou 'pdf'
    value = value.downcase
    value != 'imprimer' || value = 'print'
    ['print', 'imprimer', 'pdf'].include?(value) || raise(ERRORS[:valeurs_possibles] % ['compile_output', '"print" (impression) ou "pdf" (document PDF)'])
    compile_xml.set_xpath('//CurrentFileType', value)
    confirme(:compile_output, value.inspect)
  end



  add_modpro(
    :objectif => {hname: 'objectif', variante: 'objectif', description: 'Pour définir l’objectif du projet ou d’un document en particulier.', exemple: "\"6p\" --document=\"début du titre\"",
      category: :project_infos, confirmation: 'Objectif du %s mis à %s',
      options: []}
  )
  # TODO On doit aussi pouvoir définir --notify, --show_overrun et --show_buffer
  #      et les autres options pour un projet
  # TODO Pouvoir mettre :options à add_modpro pour afficher les options des
  #      différentes commandes
  def set_objectif value
    what = CLI.options[:document] || :projet
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
      bitem = binder_item_by_title(what)
      if yesOrNo('Voulez-vous définir l’objectif de « %s » à %i signes ?' % [bitem.title, final_value])
        bitem.target.define(final_value, {type: 'Characters', notify: false, show_overrun: true, show_buffer: true})
      else
        return
      end
    end
    confirme(:objectif, [what == :projet ? 'projet' : ('document %s ' % [bitem.title]), final_value])
  end




  # ---------------------------------------------------------------------
  # Méthode utilitaires

  def human_value_objectif_to_real_value valeur
    SWP.signs_from_human_value(valeur, true)
  end

  # Retourne la vraie valeur de +value+ en la trouvant dans
  # +data_value+. Si la valeur n'est pas trouvée, une exception
  # est levée.
  # Cette méthode permet par exemple de donner 'Plan' comme valeur
  # et de retourner 'Outliner', le nom du plan dans Scrivener.
  def real_value_in(value, data_value)
    case data_value
    when Array
      # Quand +data_value+ est une liste, on doit juste vérifier que
      # +value+ appartient bien à cette liste
      data_value.include?(value) || raise('La valeur devrait être une parmi : %s' % data_value.join(', '))
    when Hash
      data_value.key?(value) && (return value)
      # Sinon, il faut chercher la bonne valeur
      data_value.each do |real, arr_values|
        arr_values.include?(value) && (return real)
      end
      # Si on arrive ici c'est que la valeur n'a pas été trouvée
      raise('Impossible de trouver la valeur correspond à %s' % value.inspect)
    end
    nil
  rescue Exception => e
    raise_by_mode(e, Scrivener.mode)
    false
  end
  def yes_or_no_value value
    case value.to_s.downcase
    when '', 'vrai', 'true', 'yes', 'oui', 'y', 'o' then 'Yes'
    when 'no', 'non', 'n', 'false', 'faux' then 'No'
    else raise 'Valeur yes/no invalide.'
    end
  end

  # Prend n'importe quelle valeur +value+ et la retourne comme un factor
  # Scrivener. Par exemple, `100` qui signifie `100%` vaut 1.0
  def any_value_as_factor(value)
    case value
    when /^[0-9](\.[0-9]{1,2})?$/ then value # déjà un facteur
    when /^[0-9]{2,3}$/
      (value.to_f / 100).pretty_round
    when /^[0-9]{2,3}%$/
      (value[0...-1].to_f / 100).pretty_round
    else
      raise(ERRORS[:unable_to_find_factor_with] % [value.inspect, '%'])
    end.to_f
  end

  def confirme key_set, replacements = nil
    msg = MODIFIABLE_PROPERTIES[key_set][:confirmation]
    replacements.nil? || msg = msg % replacements
    puts '  – ' + msg
  end

end #/Project
end #/Scrivener
