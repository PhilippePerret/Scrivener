require_relative '../lib/document_editor_module'

class Scrivener
class Project
class UI
class MainDocumentEditor

  include DocumentEditorModule

  # Pour composer les noms, comme par exemple 'mainDocumentEditor'
  def document_editor_name
    @document_editor_name ||= 'main'
  end

  # Pour mettre cette vue en vue courante. En fait, ça revient à
  # ne plus mettre la vue supporting en vue courante
  def set_current
    projet.ui.supporting_document_editor.unset_current
  end

end #/mainDocumentEditor
end #/UI
end #/Project
end #/Scrivener
