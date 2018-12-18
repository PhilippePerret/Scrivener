# encoding: UTF-8
class Scrivener
  class Project
    class BinderItem

      attr_reader :projet, :node

      def initialize projet, node = nil
        @projet  = projet
        @node    = node
      end

    end #/BinderItem
  end #/Project
end #/Scrivener
