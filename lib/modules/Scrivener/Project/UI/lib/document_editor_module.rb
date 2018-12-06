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
    @scrollRect ||= Surface.new(ui_plist['%sDocumentEditor.scrollRect' % document_editor_name])
  end

  # {Float} Factoreur de grossissement dans l'éditeur principal
  def text_scale_factor
    @text_scale_factor ||= state['textScaleFactor']
  end
  def text_scale_factor= value
    state['textScaleFactor'] = value.to_f
    ui_plist.set_modified
  end

  def state
    @state ||= ui_plist['%sDocumentEditor.textEditorState' % document_editor_name]
  end

  # Raccourcis
  def ui_plist
    @ui_plist ||= projet.ui.ui_plist
  end

end
