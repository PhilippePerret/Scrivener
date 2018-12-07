# encoding: UTF-8
class Scrivener
  class Project
    class BinderItem

      attr_reader :project, :node

      def initialize project, node = nil
        @project  = project
        @node     = node
      end

    end #/BinderItem
  end #/Project
end #/Scrivener
