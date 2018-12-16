
# Module des méthodes pour CANON
module TextAnalyzerOutputCanonFormatTEXT

  LINE_CANON_ENTETE = Array.new
  LINE_CANON_ENTETE << ''
  LINE_CANON_ENTETE << ''
  LINE_CANON_ENTETE << "LISTE DES CANONS (classés %{type_classement})"
  LINE_CANON_ENTETE << "="*LINE_CANON_ENTETE[2].length
  LINE_CANON_ENTETE << '%s |%s| %s| %s' % [
    ' Canon '.ljust(31),
    'Nombre'. ljust(4),
    'Prox.'.ljust(4),
    'Offsets'.ljust(40)
  ]
  LINE_CANON_ENTETE << '-' * LINE_CANON_ENTETE[4].length


  def header(options)
    LINE_CANON_ENTETE.join(String::RC) % {type_classement: self.class.classement_name(options)}
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

end #/module TextAnalyzerOutputFormatTEXT

# Méthode pour les PROXIMITÉS
module TextAnalyzerOutputProximiteFormatTEXT

  LINE_PROXIMITE_ENTETE = Array.new
  LINE_PROXIMITE_ENTETE << ''
  LINE_PROXIMITE_ENTETE << ''
  LINE_PROXIMITE_ENTETE << 'LISTE DES PROXIMITES (classés %{type_classement})'
  LINE_PROXIMITE_ENTETE << '=' * LINE_PROXIMITE_ENTETE[2].length
  LINE_PROXIMITE_ENTETE << '%s |%s |%s |%s|%s |%s' % [
    ' '.ljust(5),
    ' ID '.ljust(8),
    ' Mot avant'.ljust(31),
    ' dist.'.ljust(5),
    ' Mot après'.ljust(31),
    ' Décalages'.ljust(16)
  ]
  LINE_PROXIMITE_ENTETE << '-' * LINE_PROXIMITE_ENTETE[4].length

  LINE_PROXIMITE = '%{findex}. | #%{fid} | %{pmot} | %{dist} | %{nmot} | %{foffsets}'

  class << self
    def header(options)
      'header de proximités'
    end
  end

  # Entête de la ligne d'affichage des proximités
  def header(options)
    LINE_PROXIMITE_ENTETE.join(String::RC) % {type_classement: self.class.classement_name(options)}
  end

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
    @foffsets ||= ('%s - %s' % [mot_avant.offset.to_s.rjust(7), mot_apres.offset]).ljust(15)
  end
end #/module TextAnalyzerOutputProximiteFormatTEXT

module TextAnalyzerOutputMotFormatTEXT

  LINE_MOT_ENTETE = Array.new
  LINE_MOT_ENTETE << ''
  LINE_MOT_ENTETE << 'LISTE DES MOTS (classés %{classement_name})'
  LINE_MOT_ENTETE << '=' # sera rectifié dans `header`

  LINE_MOT_ENTETE << ' %{mot} | %{occ} |' % {
    mot: 'Mot'.ljust(30),
    occ: 'Nombre'.ljust(7)
  }
  LINE_MOT_ENTETE << '-' * LINE_MOT_ENTETE[1].length

  LINE_MOT = ' %{mot} | %{index} |'
  def as_line_output(index = nil)
    LINE_MOT % {
      mot: self.real.ljust(30),
      index: self.indexes.count.to_s.rjust(7)
    }
  end

  def header(options)
    LINE_MOT_ENTETE[1] = LINE_MOT_ENTETE[1] % {classement_name: self.class.classement_name(options)}
    LINE_MOT_ENTETE[2] = '=' * LINE_MOT_ENTETE[1].length
    LINE_MOT_ENTETE.join(String::RC)
  end

end #/TextAnalyzerOutputMotFormatTEXT
