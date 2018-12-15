# encoding: UTF-8
class TextAnalyzer
class Analyse
class TableResultats
  class Proximite

    # Retourne la ligne à afficher pour la ligne de commande
    def as_line_resultat
      '#%{fid} %{pmot} <- %{dist} -> %{nmot} %{foffsets}' % {
        fid: formated_id, pmot: fprevmot, nmot: fnextmot,
        dist: fdistance, foffsets: foffsets
      }
    end

    def formated_id
      @formated_id ||= id.to_s.rjust(6)
    end
    def fprevmot
      @fprevmot ||= mot_avant.real.ljust(30)
    end
    def fnextmot
      @fnextmot ||= mot_apres.real.ljust(30)
    end
    def fdistance
      @fdistance ||= distance.to_s.rjust(4)
    end
    def foffsets
      @foffsets ||= '%s - %s' % [foffset(mot_avant), foffset(mot_apres)]
    end
    def foffset(mot)
      mot.offset.to_s.ljust(7)
    end
  end #/Proximite
end #/TableResultats
end #/Analyse
end #/TextAnalyzer
