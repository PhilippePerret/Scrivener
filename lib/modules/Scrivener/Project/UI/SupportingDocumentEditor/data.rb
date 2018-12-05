require_relative '../lib/document_editor_module'

class Scrivener
class Project
class UI
class SupportingDocumentEditor

  #
  # NOTE : bizarrement, il semble que cette "supporting" vue soit la
  #        vue principale et "main" la vue secondaire.
  #

  include DocumentEditorModule

  # Pour composer les noms, comme par exemple 'supportingDocumentEditor'
  def document_editor_name
    @document_editor_name ||= 'supporting'
  end

  def current?
    ui_plist['supportingDocumentViewIsCurrent']
  end

  # Pour faire de la vue Supporting la vue courante
  def set_current
    ui_plist.set('supportingDocumentViewIsCurrent', true)
  end
  # Pour ne plus faire de la vue Supporting la vue courante
  def unset_current
    ui_plist['supportingDocumentViewIsCurrent'] = false
    projet.ui.save_ui_plist
  end

end #/SupportingDocumentEditor
end #/UI
end #/Project
end #/Scrivener
