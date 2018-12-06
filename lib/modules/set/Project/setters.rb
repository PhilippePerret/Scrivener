# encoding: UTF-8
=begin

  NOTE
  Ce module est aussi chargé par getter.rb pour pouvoir connaitre la liste
  des propriétés MODIFIABLE_PROPERTIES.

=end
class Scrivener
  ERRORS.merge!(
    unable_to_find_factor_with: 'Impossible de trouver le facteur avec la valeur %s. Il faut soit le facteur lui-même (p.e. `1.5`), soit un pourcentage (p.e. `130%s`), soit un pourcentage sans unité (p.e. `400`).',
    valeurs_possibles: 'Les seules valeurs possibles pour %s sont %s.'
  )
class Project

  TABLE_EQUIVALENCE_DATA_SET = {
    auteur:               :author,
    auteurs:              :authors,
    compiler_sans_commentaires:   :remove_comments_on_compile,
    compiler_sans_annotations:    :remove_annotations_on_compile,
    sortie_compilation:   :compile_output,
    titre:                :title,
    titre_court:          :title_abbreviate,
    zoom_editeurs:        :zoom_editors,
    zoom_editeur:         :zoom_editor,
    zoom_autre_editeur:   :zoom_alt_editor
  }

  # Liste des méthodes, pour l'aide
  MODIFIABLE_PROPERTIES = Hash.new

  # Différents textes qu'on peut trouver pour différentes propriétés
  DIVEXPLI = {
    factor_or_pourcentage: 'On peut le définir soit par un facteur (zoom_editor=2.5) soit par un pourcentage (zoom_editor="150%").',
    yes_or_no_values: {'Yes' => [nil, 'Yes', 'yes', 'y', 'oui', 'o', 'true', 'vrai'], 'No' => ['n', 'No', 'non', 'false', 'faux']}
  }

  # ---------------------------------------------------------------------
  # Méthodes de modification des données

  # Définir l'auteur du projet
  MODIFIABLE_PROPERTIES.merge!(
    :author => {hname: 'auteur', variante: 'auteur', description: 'Pour définir le prénom et nom de l’auteur principal du projet.', exemple: "Alphonse Jouard".inspect,
      category: :project_infos, confirmation: 'Auteur principal mis à %s'}
  )
  def set_author value
    value_init = value
    value = value.split
    prenom = value.shift
    patron = value.join
    compile_xml.set_xpath('//MetaData/Surname', patron)
    compile_xml.set_xpath('//MetaData/Forename', prenom)
    # Voir si cet auteur est déjà dans la liste
    # dans le cas contraire, l'ajouter (à la fin, pour le moment).
    author_found = false
    get_authors.each do |hau|
      if hau[:firstname] == prenom && hau[:lastname] == nom
        author_found = true
        break
      end
    end
    author_found || add_an_author({tag: 'Author', text: value_init, attrs: {Role: 'aut', FileAs: ('%s, %s' % [patron, prenom])}})
    confirme(author, value)
  end

  # Définir les auteurs du projet
  MODIFIABLE_PROPERTIES.merge!(
    :authors => {hname: 'auteurs', variante: 'auteurs', description: 'Pour définir les prénoms et noms de tous les auteurs du projet.', exemple: "John Ford, Fred Vargas".inspect,
      category: :project_infos, confirmation: 'Auteurs mis à %s'}
  )
  def set_authors value
    compile_xml.remove_children_of_xpath('//MetaData/Authors')
    value.split(',').collect{|a| a.strip}.each do |patro|
      patro_init = patro
      patro = patro.split
      prenom = patro.shift
      patro = patro.join
      add_an_author({tag: 'Author', text: patro_init, attrs: {Role: 'aut', FileAs: ('%s, %s' % [patro, prenom])}})
    end
    confirme(:authors, value)
  end

  def add_an_author dauteur
    compile_xml.add_xpath('//MetaData/Authors', dauteur)
  end

  # Définir le titre du projet
  MODIFIABLE_PROPERTIES.merge!(
    :title => {hname: 'titre', variante: 'titre', description: 'Pour définir le titre complet du projet.', exemple: "Titre complet du projet".inspect,
      category: :project_infos, confirmation: 'Titre mis à « %s »'}
  )
  def set_title value
    compile_xml.set_xpath('//MetaData/ProjectTitle', value)
    confirme(:title, value)
  end

  # Définir le titre abbrégé (court) du projet
  MODIFIABLE_PROPERTIES.merge!(
    :title_abbreviate => {hname: 'titre abrégé', variante: 'titre_court', description: 'Pour définir le titre court du projet.', exemple: "Tit. court".inspect,
      category: :project_infos, confirmation: 'Titre abrégé mis à « %s »'}
  )
  def set_title_abbreviate value
    compile_xml.set_xpath('//MetaData/ProjectAbbreviatedTitle', value)
    confirme(:title_abbreviate, value)
  end

  # Définir le zoom des notes
  MODIFIABLE_PROPERTIES.merge!(
    :zoom_notes => {hname: 'zoom des notes', description: 'Pour définir la taille des notes dans l’inspecteur.', exemple: '1.5',
      category: :interface}
  )
  def set_zoom_notes value
    factor = any_value_as_factor(value)
    project.ui.notes_scale_factor= factor
    confirme(:zoom_notes, "#{(factor * 100).round} %")
  end


  # Définir le zoom de l'éditeur principal
  MODIFIABLE_PROPERTIES.merge!(
    :zoom_editor => {hname: 'zoom de l’éditeur', variante: 'zoom_editeur', description: 'Pour définir le zoom dans l’éditeur. %s' % [DIVEXPLI[:factor_or_pourcentage]], exemple: "200%".inspect,
      category: :interface, confirmation: 'Zoom de l’éditeur principal mis à %s'}
  )
  def set_zoom_editor value
    factor = any_value_as_factor(value)
    project.ui.main_document_editor.text_scale_factor= factor
    confirme(:zoom_editor, "#{(factor * 100).round} %")
  end

  # Définir le zoom de l'éditeur secondaire
  MODIFIABLE_PROPERTIES.merge!(
    :zoom_alt_editor => {hname: 'zoom de l’éditeur alternatif', variante: 'zoom_autre_editeur', description: 'Pour définir le zoom dans le second éditeur. %s' % [DIVEXPLI[:factor_or_pourcentage]], exemple: "2",
      category: :interface, confirmation: 'Zoom de l’éditeur alternatif mis à %s'}
  )
  def set_zoom_alt_editor value
    factor = any_value_as_factor(value)
    project.ui.supporting_document_editor.text_scale_factor= factor
    confirme(:zoom_alt_editor, "#{(factor * 100).round} %")
  end

  MODIFIABLE_PROPERTIES.merge!(
    :zoom_editors => {hname: 'zoom des deux éditeurs', variante: 'zoom_editeurs', description: 'Pour définir le zoom dans les deux éditeurs en même temps. %s' % [DIVEXPLI[:factor_or_pourcentage]], exemple: "250".inspect,
      category: :interface}
  )
  def set_zoom_editors value
    set_zoom_editor value
    set_zoom_alt_editor value
  end

  MODIFIABLE_PROPERTIES.merge!(
    :remove_comments_on_compile => {hname: 'Ne pas compiler les commentaires', variante: 'compiler_sans_commentaires', description: 'Pour compiler le projet sans ou avec les commentaires', exemple: 'vrai', values: DIVEXPLI[:yes_or_no_values],
      category: :compilation, confirmation: 'Suppression ou ajout des commentaires à la compilation mis à %s'}
  )
  def set_remove_comments_on_compile value
    value = yes_or_no_value(value)
    compile_xml.set_xpath('//Options/RemoveComments', value)
    confirme(:remove_comments_on_compile, value)
  end

  MODIFIABLE_PROPERTIES.merge!(
    :remove_annotations_on_compile => {hname: 'Suppression des annotations à la compilation', variante: 'compiler_sans_annotations', description: 'Pour compiler le projet avec ou sans les annotations.', exemple: 'Oui', values: DIVEXPLI[:yes_or_no_values],
      category: :compilation, confirmation: 'suppression ou ajout des annotations à la compilation défini'}
  )
  # puts "DIVEXPLI[:yes_or_no_values]: #{DIVEXPLI[:yes_or_no_values].inspect}"
  def set_remove_annotations_on_compile value
    compile_xml.set_xpath('//Options/RemoveAnnotations', yes_or_no_value(value))
    confirme(:remove_annotations_on_compile)
  end


  MODIFIABLE_PROPERTIES.merge!(
    :compile_output => {hname: 'Type de sortie de la compilation', variante: 'sortie_compilation', description: 'Pour définir s’il faut imprimer ou créer un document PDF lors de la compilation.', exemple: 'PDF', values: {'un document PDF' => ['pdf', 'PDF'], 'imprimer le projet' => ['print', 'PRINT', 'imprimer']},
      category: :compilation, confirmation: 'Format de sortie de compilation mis à %s'}
  )
  def set_compile_output value
    # Value doit être 'print' ou 'pdf'
    value = value.downcase
    value != 'imprimer' || value = 'print'
    ['print', 'imprimer', 'pdf'].include?(value) || raise(ERRORS[:valeurs_possibles] % ['compile_output', '"print" (impression) ou "pdf" (document PDF)'])
    compile_xml.set_xpath('//CurrentFileType', value)
    confirme(:compile_output, value)
  end

  # ---------------------------------------------------------------------
  # Méthode utilitaires

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
    when /^[0-9]\.[0-9]{1,2}$/ then value # déjà un facteur
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
    puts msg
  end

end #/Project
end #/Scrivener
