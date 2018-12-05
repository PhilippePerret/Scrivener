class Scrivener
class Project
class UI

  def main_document_editor
    @main_document_editor ||= MainDocumentEditor.new(self.projet)
  end

  def supporting_document_editor
    @supporting_document_editor ||= SupportingDocumentEditor.new(self.projet)
  end

  def full_screen
    @full_screen ||= FullScreen.new(self.projet)
  end

end #/UI
end #/Project
end #/Scrivener
