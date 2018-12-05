# encoding: UTF-8
class Scrivener
class Project
class UI
class FullScreen

  attr_accessor :projet

  def initialize iprojet
    self.projet = iprojet
  end

  def text_scale_factor
    @text_scale_factor ||= text_editor_setting['textScaleFactor']
  end

  def text_scale_factor= value
    text_editor_setting['textScaleFactor'] = value
    ui_plist.save
  end

  def text_editor_setting
    @text_editor_setting ||= ui_plist['fullScreenTextEditorSettings']
  end

  # Raccourcis
  def ui_plist
    @ui_plist ||= projet.ui.ui_plist
  end

end #/FullScreen
end #/UI
end #/Project
end #/Scrivener
