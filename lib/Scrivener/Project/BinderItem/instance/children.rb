# encoding: UTF-8
class Scrivener
  class Project
    class BinderItem

      # Liste des enfants sous forme d'instance Scrivener::Project::BinderItem
      def children
        @children ||= node.elements.collect('Children/BinderItem'){|c| Scrivener::Project::BinderItem.new(project, c)}
      end

    end #/BinderItem
  end #/Project
end #/Scrivener
