class Scrivener
  class Project

    def path_segments
      @path_segments ||= File.join(project.hidden_folder, 'table_segments.msh')
    end

    def path_proximites
      @path_proximites ||= File.join(project.hidden_folder, 'tableau_proximites.msh')
    end

  end #/Project
end #/Scrivener
