
class Scrivener
  class Project

    def folders
      @folders ||= begin
        ActiveList.new(self.xfile.binder.elements.collect {|xmlNode| Scrivener::Project::BinderItem.new(self, xmlNode)}, self)
      end
    end

  end #/Project
end #/Scrivener
