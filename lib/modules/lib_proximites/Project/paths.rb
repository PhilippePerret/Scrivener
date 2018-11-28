class Scrivener
  class Project

    def watch_whole_texte_path
      @watch_whole_texte_path ||= File.join(hidden_folder, 'watch_whole_texte.txt')
    end
    def watch_lemma_file_path
      @watch_lemma_file_path ||= File.join(hidden_folder, 'watch_lemma_data')
    end

  end #/Project
end #/Scrivener
