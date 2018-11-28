=begin
=end
class Scrivener
  class Project
    class << self

      attr_accessor :current

      # Pour définir le projet courant, pour le raccourci `project` qui
      # servira partout.
      def get_current_project_or_nil
        return Scrivener.project_path ? Scrivener::Project.new(Scrivener.project_path) : nil
      end

    end #/<< self
  end #/Project
end #/Scrivener


def project
  Scrivener::Project.current ||= Scrivener::Project.get_current_project_or_nil
end
alias :current_project :project
