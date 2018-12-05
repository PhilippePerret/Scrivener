# encoding: UTF-8
class Scrivener
class Project
class UI

  def ui_plist
    @ui_plist ||= Plist.parse_xml(projet.ui_plist_path)
  end

  # Pour sauver l'ui_plist modifiée
  def save_ui_plist
    File.open(projet.ui_plist_path,(wb)){|f| f.write Plist::Emit.dump(ui_plist)}
  end

end #/UI
end #/Project
end #/Scrivener
