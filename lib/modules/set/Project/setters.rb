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

  # Liste des méthodes, pour l'aide
  MODIFIABLE_PROPERTIES = Hash.new

  # Différents textes qu'on peut trouver pour différentes propriétés
  DIVEXPLI = {
    factor_or_pourcentage: 'On peut le définir soit par un facteur (zoom_editor=2.5) soit par un pourcentage (zoom_editor="150%").',
    yes_or_no_values: {'Yes' => [nil, 'Yes', 'yes', 'y', 'oui', 'o', 'true', 'vrai'], 'No' => ['n', 'No', 'non', 'false', 'faux']},
    modes_vues: {'Single' => ['Single', 'Texte', 'Text', 'T'], 'Scrivenings' => ['Scrivenings', 'Textes', 'S'], 'Corkboard' => ['Corkboard', 'Tableau', 'C'], 'Outliner' => ['Plan', 'Outliner', 'O']}
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

  QUESTIONS = {
    set_project_name: 'Voulez-vous mettre le nom du projet %s à %s ?'
  }

  # Définir le nom de fichier du projet
  add_modpro(:name => { hname: 'Nom du fichier',
                        variante: 'nom',
                        description: 'Pour définir le nom du fichier du projet.',
                        exemple: "nouveau_nom".inspect,
                        category: :project_infos,
                        confirmation: 'Nom du fichier mis à %s',
                        not_in_yam_file: true,
                        default: 'null'
                      })
  def set_name value
    value === nil && return # quand un fichier de configuration met à null la valeur
    new_nom = value.gsub(/ /, '_')
    new_nom.end_with?('.scriv') || new_nom.concat('.scriv')
    if yesOrNo(QUESTIONS[:set_project_name] % [File.basename(path).inspect, new_nom.inspect])
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
  add_modpro(:title =>  { hname: 'Titre du projet',
                          variante: 'titre',
                          description: 'Pour définir le titre complet du projet.',
                          exemple: 'title="Titre complet du projet"',
                          category: :project_infos,
                          confirmation: 'Titre mis à « %s »',
                          default: 'null'
                        }
  )
  # TODO On devrait pouvoir définir le titre d'un document de cette manière
  # aussi, avec l'option '-doc="début du titre actuel"'
  def set_title value
    value === nil && return
    compile_xml.set_xpath('//MetaData/ProjectTitle', value)
    confirme(:title, value)
  end

  # Définir le titre abbrégé (court) du projet
  add_modpro(:title_abbreviated => {hname: 'Titre abrégé du projet',
                                    variante: 'titre_court',
                                    description: 'Pour définir le titre court du projet.',
                                    exemple: 'title_abbreviated="Tit. court"',
                                    category: :project_infos,
                                    confirmation: 'Titre abrégé mis à « %s »',
                                    default: 'null'
                                  })
  def set_title_abbreviated value
    value === nil && return
    compile_xml.set_xpath('//MetaData/ProjectAbbreviatedTitle', value)
    confirme(:title_abbreviated, value)
  end


  # Définir l'auteur du projet
  # Note : chaque setter doit définir cette valeur pour tenir à jour la
  # table des matières.
  add_modpro(:author => { hname: 'Auteur du projet',
                          variante: 'auteur',
                          description: 'Pour définir le prénom et nom de l’auteur principal du projet.',
                          exemple: "Alphonse Jouard".inspect,
                          category: :project_infos,
                          confirmation: 'Auteur principal mis à %s',
                          default: 'null'
                        })
  # Trois façons de le définir avec +value+ :
  #   - "Prénom Nom"
  #   - "Nom, Prénom"
  #   - {firstname: "Prénom", lastname: "Nom"}
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
  add_modpro(:authors => {  hname: 'Auteurs du projet',
                            variante: 'auteurs',
                            description: 'Pour définir les prénoms et noms de tous les auteurs du projet.',
                            exemple: "John Ford, Fred Vargas".inspect,
                            category: :project_infos,
                            confirmation: 'Auteurs mis à %s',
                            default: 'null'
                          })
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
  add_modpro(:binder_visible => { hname: 'Visibilité du classeur',
                                  variante: 'classeur_visible',
                                  description: 'Pour définir la visibilité du classeur.',
                                  exemple: 'binder_visible=non',
                                  values: DIVEXPLI[:yes_or_no_values],
                                  category: [:interface, :binder],
                                  confirmation: 'Visibilité du classeur mise à %s',
                                  default: 'Yes'
                                })
  def set_binder_visible value
    value === nil && return
    value = yes_or_no_value(value)
    project.ui_common.binder.visibility(value == 'Yes')
    confirme(:binder_visible, value.inspect)
  end

  add_modpro(:collections_visible => {hname: 'Visibilité des collections',
                                      variante: nil,
                                      description: 'Pour définir la visibilité des collections dans le classeur.',
                                      exemple: 'collections_visible=o',
                                      values: DIVEXPLI[:yes_or_no_values],
                                      category: [:interface, :binder],
                                      confirmation: 'Visibilité des collections dans le classeur mise à %s',
                                      default: 'Yes'
                                    })
  def set_collections_visible value
    value === nil && return
    value = yes_or_no_value(value)
    project.ui_common.collections_visibility(value == 'Yes')
    confirme(:collections_visible, value.inspect)
  end

  # ---------------------------------------------------------------------
  #   MÉTHODES INTERFACE ÉDITEURS

  add_modpro(:editors_header => { hname: 'Visibilité des entêtes des éditeurs',
                                  variante: 'entete_editeurs',
                                  description: 'Pour définir si les entêtes doivent être visibles dans les deux éditeurs.',
                                  exemple: 'editors_header=Yes',
                                  values: DIVEXPLI[:yes_or_no_values],
                                  category: [:interface, :editors],
                                  confirmation: 'Visibilité des entêtes mise à %s',
                                  default: 'Yes'
                                })
  def set_editors_header value
    value === nil && return
    value = yes_or_no_value(value)
    project.ui_common.editor1.header_visible(value == 'Yes')
    project.ui_common.editor2.header_visible(value == 'Yes')
    confirme(:editors_header, value.inspect)
  end

  add_modpro(:editors_footer => { hname: 'Visibilité des pieds de page des éditeurs',
                                  variante: 'pied_de_page_editeurs',
                                  description: 'Pour définir si les pieds de page doivent être visibles dans les deux éditeurs.',
                                  exemple: 'editors_footer=Y',
                                  values: DIVEXPLI[:yes_or_no_values],
                                  category: [:interface, :editors],
                                  confirmation: 'Visibilité des pieds de page mise à %s',
                                  default: 'Yes'
                                })
  def set_editors_footer value
    value === nil && return
    value = yes_or_no_value(value)
    project.ui_common.editor1.footer_visible(value == 'Yes')
    project.ui_common.editor2.footer_visible(value == 'Yes')
    confirme(:editors_footer, value.inspect)
  end

  add_modpro(
    :editors_selection => { hname: 'Sélection de texte dans les éditeurs',
                            real:       'editor1_selection, editor2_selection',
                            variante:   'selection_editeur1 (ou 2)',
                            description: 'Pour définir la sélection de texte dans les éditeur',
                            exemple: 'editors_selection="10, 30"',
                            values:  '<offset start>, <offset end>',
                            category: [:interface, :editors],
                            confirmation: 'Sélection de l’éditeur %i mis à %s',
                            default: 'null'
                          })
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

  add_modpro(:editor_view_mode => { hname: 'Mode de vue de l’éditeur principal',
                                    variante: 'mode_vue_editeur',
                                    description: 'Pour définir le mode d’affichage de l’éditeur principal, c’est-à-dire pour définir s’il doit afficher le ou les textes, le tableau d’affichage ou le plan.',
                                    exemple: 'editor_view_mode=Plan',
                                    values: DIVEXPLI[:modes_vues],
                                    category: [:interface, :editors],
                                    confirmation: 'Mode courant de vue de l’éditeur principal mis à %s',
                                    default: 'Single'
                          })
  def set_editor_view_mode value
    value === nil && return
    value = real_value_in(value.capitalize, DIVEXPLI[:modes_vues]) || return
    project.ui_common.editor1.current_view_mode= value
    confirme(:editor_view_mode, value.inspect)
  end

  add_modpro( :editors_group_view_mode => { hname: 'Mode de vue de groupe dans les éditeurs',
                                            real: 'editor1_group_view_mode, editor2_group_view_mode',
                                            variante: 'mode_vue_groupe_editeur1 (ou 2)',
                                            description: 'Pour définir le mode d’affichage d’un groupe de documents ou de dossier dans l’éditeur principal, c’est-à-dire pour définir s’il doit afficher les textes, le tableau d’affichage ou le plan.',
                                            exemple: 'editors_group_view_mode=Plan',
                                            values: DIVEXPLI[:modes_vues],
                                            category: [:interface, :editors],
                                            confirmation: 'Mode courant de vue de groupe de l’éditeur %i mis à %s',
                                            default: 'Single'
                                          })
  def set_editor1_group_view_mode value
    set_editor_group_view_mode(1, value)
  end
  def set_editor2_group_view_mode value
    set_editor_group_view_mode(2, value)
  end
  def set_editor_group_view_mode index_editor, value
    value === nil && return
    value = real_value_in(value.capitalize, DIVEXPLI[:modes_vues]) || return
    project.ui_common.send("editor#{index_editor}".to_sym).group_view_mode= value
    confirme(:editors_group_view_mode, [index_editor, value.inspect])
  end

  # ---------------------------------------------------------------------
  #   MÉTHODES INTERFACE INSPECTEUR

  add_modpro(:inspector_visible => {hname: 'Visibilité de l’inspecteur',
                                    variante: 'inspecteur_visible',
                                    description: 'Pour définir la visibilité de l’inspecteur.',
                                    exemple: 'inspector_visible=No',
                                    values: DIVEXPLI[:yes_or_no_values],
                                    category: [:interface, :inspector],
                                    confirmation: 'Visibilité de l’inspecteur mise à %s',
                                    default: 'Yes'
                                  })
  def set_inspector_visible value
    value === nil && return
    value = yes_or_no_value(value)
    project.ui_common.inspector.visibility(value == 'Yes')
    confirme(:inspector_visible, value.inspect)
  end

  add_modpro(:inspector_tab => {  hname: 'Onglet de l’inspecteur',
                                  variante: 'onglet_inspecteur',
                                  description: 'Pour définir l’onglet courant de l’inspecteur.',
                                  exemple: 'inspector_tab=Bookmarks',
                                  method_values: :inspector_tabs_valid_values,
                                  category: [:interface, :inspector],
                                  confirmation: 'Onglet courant de l’inspecteur mis à %s',
                                  default: 'Notes'
                                })
  def set_inspector_tab value
    value === nil && return
    UI::UICommon::Inspector::ONGLETS[value.downcase.to_sym] || raise(ERRORS[:bad_onglet_inspector])
    project.ui_common.inspector.set_onglet(value)
    confirme(:inspector_tab, value.inspect)
  end

  # Définir le zoom des notes
  add_modpro(:zoom_notes => { hname: 'zoom des notes',
                              description: 'Pour définir la taille des notes dans l’inspecteur.',
                              exemple: 'zoom_notes=1.5',
                              category: [:interface, :inspector],
                              confirmation: 'Zoom des notes dans l’inspecteur mis à %s',
                              default: '100'
                            })
  def set_zoom_notes value
    value === nil && return
    factor = any_value_as_factor(value)
    project.ui.notes_scale_factor= factor
    confirme(:zoom_notes, "#{(factor * 100).round}%")
  end

  # Définir le zoom de l'éditeur principal
  add_modpro(:zoom_editor => {  hname: 'zoom de l’éditeur',
                                variante: 'zoom_editeur',
                                description: 'Pour définir le zoom dans l’éditeur. %s' % [DIVEXPLI[:factor_or_pourcentage]],
                                exemple: "zoom_editor=200%".inspect,
                                category: :interface,
                                confirmation: 'Zoom de l’éditeur principal mis à %s',
                                default: '100'
                              })
  def set_zoom_editor value
    value === nil && return
    factor = any_value_as_factor(value)
    project.ui.main_document_editor.text_scale_factor= factor
    confirme(:zoom_editor, "#{(factor * 100).round}%")
  end

  # Définir le zoom de l'éditeur secondaire
  add_modpro(:zoom_alt_editor => {  hname: 'zoom de l’éditeur alternatif',
                                    variante: 'zoom_autre_editeur',
                                    description: 'Pour définir le zoom dans le second éditeur. %s' % [DIVEXPLI[:factor_or_pourcentage]],
                                    exemple: "zoom_alt_editor=2",
                                    category: [:interface, :editors],
                                    confirmation: 'Zoom de l’éditeur alternatif mis à %s',
                                    default: '100'
                                  })
  def set_zoom_alt_editor value
    value === nil && return
    factor = any_value_as_factor(value)
    project.ui.supporting_document_editor.text_scale_factor= factor
    confirme(:zoom_alt_editor, "#{(factor * 100).round}%")
  end

  add_modpro(:zoom_editors => { hname: 'zoom des deux éditeurs',
                                variante: 'zoom_editeurs',
                                description: 'Pour définir le zoom dans les deux éditeurs en même temps. %s' % [DIVEXPLI[:factor_or_pourcentage]],
                                exemple: 'zoom_editors=250',
                                category: [:interface, :editors],
                                default: '100'
                              })
  def set_zoom_editors value
    value === nil && return
    set_zoom_editor value
    set_zoom_alt_editor value
  end

  add_modpro(:compile_comments => { hname: 'Ne pas compiler les commentaires',
                                              variante: 'compiler_sans_commentaires',
                                              description: 'Pour compiler le projet sans ou avec les commentaires',
                                              exemple: 'compile_comments=vrai',
                                              values: DIVEXPLI[:yes_or_no_values],
                                              category: :compilation,
                                              confirmation: 'Ajout des commentaires à la compilation mis à %s',
                                              default: 'false'
                                            })
  def set_compile_comments value
    value === nil && return
    value = yes_or_no_value(value) == 'Yes' ? 'No' : 'Yes'
    compile_xml.remove_comments= value
    confirme(:compile_comments, value)
  end

  add_modpro(:compile_annotations => { hname: 'Suppression des annotations à la compilation',
                                            variante: 'compiler_les_annotations',
                                            description: 'Pour compiler le projet avec ou sans les annotations.',
                                            exemple: 'compile_annotations=Oui',
                                            values: DIVEXPLI[:yes_or_no_values],
                                            category: :compilation,
                                            confirmation: 'Ajout des annotations à la compilation mis à %s',
                                            default: 'false'
                                          })
  def set_compile_annotations value
    value === nil && return
    value = yes_or_no_value(value) == 'Yes' ? 'No' : 'Yes'
    compile_xml.remove_annotations = value
    confirme(:compile_annotations, value)
  end


  add_modpro(:compile_output => { hname: 'Type de sortie de la compilation',
                                  variante: 'sortie_compilation',
                                  description: 'Pour définir s’il faut imprimer ou créer un document PDF lors de la compilation.',
                                  exemple: 'compile_output=PDF',
                                  method_values: :compile_output_valid_values,
                                  category: :compilation,
                                  confirmation: 'Format de sortie de compilation mis à %s',
                                  default: 'Print'
                                })

  def set_compile_output value
    value === nil && return
    # Value doit être 'print' ou 'pdf'
    dvalue = XMLCompile::OUTPUT_FORMATS[value.downcase.to_sym] || raise(ERRORS[:valeurs_possibles] % ['compile_output', '(demande l’aide avec `scriv set compile_output -h`)'])
    compile_xml.set_xpath('//CurrentFileType', dvalue[:value])
    confirme(:compile_output, dvalue[:hname])
  end

  add_modpro(:target => {   hname: 'cible',
                            variante: 'objectif',
                            description: 'Pour définir l’objectif du projet ou d’un document en particulier.',
                            exemple: "target=\"6p\" --document=\"début du titre\"",
                            in_yaml_file: '"<début titre>::<longueur>" (par exemple : "Début du titre::6p")',
                            category: :project_infos,
                            confirmation: 'Objectif du %s mis à %s',
                            options: [],
                            default: 'null'
                          }
  )
  # TODO On doit aussi pouvoir définir --notify, --show_overrun et --show_buffer
  #      et les autres options pour un projet
  # TODO Pouvoir mettre :options à add_modpro pour afficher les options des
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


  add_modpro(:targets => {  hname: 'objectifs',
                            variante: 'objectifs',
                            description: 'Pour définir les objectifs de plusieurs documents.',
                            in_yaml_file: 'objectifs: ["<début titre>::<longueur>", "<autre début>::<longueur>"]',
                            only_in_yaml_file: true,
                            category: [:documents],
                            confirmation: 'Les objectifs ont été définis',
                            default: 'null'
                          })
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
