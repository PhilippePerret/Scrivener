# encoding: UTF-8
class Scrivener
class Project

  def ui_plist_path
    @ui_plist_path ||= File.join(settings_folder_path, 'ui.plist')
  end
  
end #/Project
end #/Scrivener
