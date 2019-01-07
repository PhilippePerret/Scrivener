# frozen_string_literal: true
# encoding: UTF-8
=begin

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
    file_name:                    :name,
    inspecteur_visible:           :inspector_visible,
    pied_de_page_editeurs:        :editors_footer,
    mode_vue_editeur:             :editor_view_mode,
    mode_vue_groupe_editeur1:     :editor1_group_view_mode,
    mode_vue_groupe_editeur2:     :editor2_group_view_mode,
    nom:                          :name,
    nom_fichier:                  :name,
    selection_editeur1:           :editor1_selection,
    selection_editeur2:           :editor2_selection,
    sortie_compilation:           :compile_output,
    titre:                        :title,
    titre_court:                  :title_abbreviated,
    zoom_editeurs:                :zoom_editors,
    zoom_editeur:                 :zoom_editor,
    zoom_autre_editeur:           :zoom_alt_editor
  }

end #/Project
end #/Scrivener
