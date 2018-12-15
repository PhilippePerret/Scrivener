module TextAnalyzerOutputCanonFormatHTML

  # TODO
  LINE_CANON_ENTETE = '<div>ENTÊTE À DÉFINIR POUR LES CANONS</div>'
  LINE_CANON = '<div><span class="canon">%{canon}</span></div>'
  # Ligne pour l'affichage d'un canon dans le format HTML
  def as_line_output index = nil
    LINE_CANON % {canon: fcanon}
  end

  def fcanon
    canon.to_s
  end

end #/TextAnalyzerOutputCanonFormatHTML


module TextAnalyzerOutputProximiteFormatHTML

  # TODO
  LINE_PROXIMITE_ENTETE = '<div> ENTÊTE À DÉFINIR POUR LES PROXIMITÉS</div>'
  LINE_PROXIMITE = '<div><span>#%{fproxid}</span><span>%{pmot}</span><span>%{nmot}</span></div>'
  def as_line_output index = nil
    LINE_PROXIMITE  % {
      fproxid: formated_id,
      pmot: fprevmot, nmot: fnextmot
    }
  end
  def formated_id
    @formated_id ||= id.to_s
  end
  def fprevmot
    @fprevmot ||= mot_avant.real
  end
  def fnextmot
    @fnextmot ||= mot_apres.real
  end
end #/TextAnalyzerOutputProximiteFormatHTML
