
# Module des méthodes pour CANON
module TextAnalyzerOutputCanonFormatTEXT

    LINE_CANON_ENTETE = String::RC * 2
    LINE_CANON_ENTETE << "LISTE DES CANONS (classés %{type_classement})" + String::RC
    LINE_CANON_ENTETE << "="*50 + String::RC
    LINE_CANON_ENTETE << '%s |%s| %s| %s' % [
      ' Canon '.ljust(31),
      'Nombre'. ljust(4),
      'Prox.'.ljust(4),
      'Offsets'.ljust(40)
    ]
    LINE_CANON_ENTETE << String::RC + '-' * 110

    def header(options)
      LINE_CANON_ENTETE % {type_classement: classement_name(options)}
    end


    LINE_CANON = ' %{canon} | %{occ} | %{proxs} | %{foffsets}'
    # Ligne pour l'affichage d'un canon dans le format HTML
    def as_line_output index = nil
      LINE_CANON % {
        canon: fcanon, occ: foccurences, foffsets: foffsets,
        proxs: fproxs
      }
    end

    def fcanon
      @fcanon ||= self.canon.ljust(30)
    end

    def foccurences
      @foccurences ||= self.mots.count.to_s.rjust(4)
    end

    def foffsets
      @foffsets ||= self.mots.collect{|m|m.offset}.join(', ')
    end

    # nombre de proximités dans ce canon
    def fproxs
      @fproxs ||= self.proximites.count.to_s.rjust(4)
    end

    # Le nom du classement en fonction des options
    def classement_name options
      case options[:sorted_by]
      when :mots_count
        'par nombre de mots'
      when :proximites_count
        'par nombre de proximités'
      else # :alpha
        'alphabétiquement'
      end
    end
end #/module TextAnalyzerOutputFormatTEXT

# Méthode pour les PROXIMITÉS
module TextAnalyzerOutputProximiteFormatTEXT

  LINE_PROXIMITE_ENTETE = String::RC * 2
  LINE_PROXIMITE_ENTETE << 'LISTE DES PROXIMITES' + String::RC
  LINE_PROXIMITE_ENTETE << '====================' + String::RC
  LINE_PROXIMITE_ENTETE << '%s |%s |%s |%s|%s |%s' % [
    ' '.ljust(5),
    ' ID '.ljust(8),
    ' Mot avant'.ljust(31),
    ' dist.'.ljust(5),
    ' Mot après'.ljust(31),
    ' Décalages'.ljust(16)
  ]
  LINE_PROXIMITE_ENTETE << String::RC + '-'*110

  LINE_PROXIMITE = '%{findex}. | #%{fid} | %{pmot} | %{dist} | %{nmot} | %{foffsets}'
  # Retourne la ligne à afficher pour la ligne de commande
  def as_line_output index = nil
     LINE_PROXIMITE % {
      findex: index.to_s.rjust(4),
      fid: formated_id, pmot: fprevmot, nmot: fnextmot,
      dist: fdistance, foffsets: foffsets
    }
  end

  def formated_id
    @formated_id ||= id.to_s.ljust(6)
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
end #/module TextAnalyzerOutputProximiteFormatTEXT
