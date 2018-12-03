# encoding: UTF-8
class Scrivener
  class Project

    def title
      @title || get_long_title
    end

    def title_abbreviated
      @title_abbreviated ||= get_abbreviate_title
    end

    def authors
      @authors ||= get_authors
    end

    # Liste des mots sans canonisation. Noter qu'il faut avoir lancé une
    # analyse de proximité pour pouvoir avoir accès à cette donnée.
    def real_mots
      @real_mots ||= tableau_proximites[:real_mots]
    end

  end #/Project
end #/Scrivener
