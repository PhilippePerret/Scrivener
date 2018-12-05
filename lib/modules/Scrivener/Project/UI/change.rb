class Scrivener
class Project
class UI

  # Donnée de découpage du classeur à sauver
  def binder_split_frames_to_plist
    binder_split_frames.collect do |isurface|
      isurface.to_plist
    end
  end
  # /binder_split_frames_to_plist

  # Donnée de découpage de l'éditeur à sauver
  def editor_split_frames_to_plist
    editor_split_frames.collect do |isurface|
      isurface.to_plist
    end
  end

end #/UI
end #/Project
end #/Scrivener
