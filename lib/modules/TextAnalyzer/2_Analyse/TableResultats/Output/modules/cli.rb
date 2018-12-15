module TextAnalyzerOutputFormatCLI



    LINE_CANON = '%{canon} | %{occ} |'
    # Ligne pour l'affichage d'un canon dans le format HTML
    def as_line_output
      LINE_CANON % {canon: fcanon, occ: foccurences}
    end

    def fcanon
      @fcanon ||= canon.ljust(30)
    end

    def foccurences
      @foccurences ||= canon.count.to_s.rjust(4)
    end


end #/TextAnalyzerOutputFormatHTML
