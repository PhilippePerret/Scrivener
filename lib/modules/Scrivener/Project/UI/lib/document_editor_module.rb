# encoding: UTF-8
module DocumentEditorModule

  attr_accessor :projet
  def initialize projet
    self.projet = projet
  end

  # {Surface} ???
  #
  # Note : utiliser scrollRect.to_plist pour l'enregistrer
  def scrollRect
    @scrollRect ||= Surface.new(ui_plist['supportingDocumentEditor.scrollRect'])
  end

  # {Float} Factoreur de grossissement dans l'éditeur principal
  def text_scale_factor
    @text_scale_factor ||= state['textScaleFactor']
  end
  def text_scale_factor= value
    text_scale_factor = value.to_f
    projet.ui.save_ui_plist
  end

  def state
    @state ||= ui_plist['mainDocumentEditor.textEditorState']
  end

  # Raccourcis
  def ui_plist
    @ui_plist ||= projet.ui.ui_plist
  end
end
