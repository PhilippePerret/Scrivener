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

  end #/Project
end #/Scrivener
