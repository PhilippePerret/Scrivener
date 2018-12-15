module TextAnalyzerOutputFormatHTML

    LINE_CANON = '<div><span class="canon">%{canon}</span></div>'
    # Ligne pour l'affichage d'un canon dans le format HTML
    def as_line_output
      LINE_CANON % {canon: fcanon}
    end

    def fcanon
      canon.to_s
    end

end #/TextAnalyzerOutputFormatHTML
