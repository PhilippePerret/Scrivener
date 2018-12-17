
# Module des méthodes pour CANON
module TextAnalyzerOutputCanonFormatTEXT

  TITRE_LISTING = '  LISTE %{des} CANONS (classés %{type_classement})'
  LINE_CANON_ENTETE = Array.new
  LINE_CANON_ENTETE << ''
  LINE_CANON_ENTETE << '<calculé plus tard suivant classement>'
  LINE_CANON_ENTETE <<  '='
  LINE_CANON_ENTETE << ''
  LINE_CANON_ENTETE << '  %s |%s| %s| %s' % [
    ' Canon '.ljust(31),
    'Nombre'. ljust(4),
    'Prox.'.ljust(4),
    'Offsets'.ljust(40)
  ]
  LINE_CANON_ENTETE << '-' * LINE_CANON_ENTETE[4].length


  def header(options)
    titre_listing = TITRE_LISTING % {
      des: options[:limit] == Float::INFINITY ? 'DE TOUS LES' : ('DES %s PREMIERS' % options[:limit]),
      type_classement: self.class.classement_name(options)
    }
    LINE_CANON_ENTETE[1] = titre_listing
    LINE_CANON_ENTETE[2] = '  ='.ljust(LINE_CANON_ENTETE[1].length, '=')
    LINE_CANON_ENTETE.join(String::RC)
  end

  def footer(options = nil)
    LINE_CANON_ENTETE[5]
  end


  LINE_CANON = '   %{canon} | %{occ} | %{proxs} | %{foffsets}'
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

  TITRE_LISTING = '  LISTE %{des} PROXIMITÉS (classés %{type_classement})'
  LINE_PROXIMITE_ENTETE = Array.new
  LINE_PROXIMITE_ENTETE << ''
  LINE_PROXIMITE_ENTETE << '<titre calculé plus tard suivant classement>'
  LINE_PROXIMITE_ENTETE << '=' # recalculé plus tard
  LINE_PROXIMITE_ENTETE << ''
  LINE_PROXIMITE_ENTETE << '%s |%s |%s |%s|%s |%s' % [
    ' '.ljust(5),
    ' ID '.ljust(8),
    ' Mot avant'.ljust(31),
    ' dist.'.ljust(5),
    ' Mot après'.ljust(31),
    ' Décalages'.ljust(16)
  ]
  LINE_PROXIMITE_FOOTER = '-' * (LINE_PROXIMITE_ENTETE[4].length + 2)
  LINE_PROXIMITE_ENTETE << LINE_PROXIMITE_FOOTER

  LINE_PROXIMITE = '%{findex}. | #%{fid} | %{pmot} | %{dist} | %{nmot} | %{foffsets}'

  # Entête de la ligne d'affichage des proximités
  def header(options)
    LINE_PROXIMITE_ENTETE[1] = TITRE_LISTING % {
      des: options[:limit] == Float::INFINITY ? 'DE TOUS LES' : ('DES %s PREMIERS' % options[:limit]),
      type_classement: self.class.classement_name(options)
    }
    LINE_PROXIMITE_ENTETE[2] = '  ='.ljust(LINE_PROXIMITE_ENTETE[1].length,'=')
    LINE_PROXIMITE_ENTETE.join(String::RC)
  end
  def footer_line
    LINE_PROXIMITE_FOOTER + String::RC * 2
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

  TITRE_LISTING = '  LISTE %{des} MOTS (classés %{type_classement})'
  LINE_MOT_ENTETE = Array.new
  LINE_MOT_ENTETE << ''
  LINE_MOT_ENTETE << '  LISTE DES MOTS (classés %{classement_name})'
  LINE_MOT_ENTETE << '=' # sera rectifié dans `header`
  LINE_MOT_ENTETE << ''
  LINE_MOT_ENTETE << ' %{mot} | %{occ} | %{pindex} | %{lindex}' % {
    mot: 'Mot'.ljust(30),
    occ: 'Nombre'.ljust(7),
    pindex: 'Index  1'.ljust(8),
    lindex: 'Index -1'.ljust(8)
  }
  LINE_MOT_FOOTER = '-' * (LINE_MOT_ENTETE[4].length + 2)
  LINE_MOT_ENTETE << LINE_MOT_FOOTER

  LINE_MOT = ' %{mot} | %{occs} | %{findex} | %{lindex} |'
  def as_line_output(index = nil)
    # Pour le(s) mot(s), on doit récupérer la donnée TableResultats#mots qui
    # liste le nombre d'index
    mot_tblres = self.analyse.table_resultats.mots[self.lemma]
    nb_offsets = mot_tblres.count
    LINE_MOT % {
      mot: self.real.ljust(30),
      occs:  nb_offsets.to_s.ljust(7),
      findex: mot_tblres[0].to_s.rjust(8),
      lindex: (nb_offsets > 1 ? mot_tblres[-1].to_s : ' - ').rjust(8)
    }
  end

  def header(options)
    LINE_MOT_ENTETE[1] = TITRE_LISTING % {
      des: options[:limit] == Float::INFINITY ? 'DE TOUS LES' : ('DES %s PREMIERS' % options[:limit]),
      type_classement: self.class.classement_name(options)
    }
    LINE_MOT_ENTETE[2] = '  ='.ljust(LINE_MOT_ENTETE[1].length, '=')
    LINE_MOT_ENTETE.join(String::RC)
  end
  def footer_line
    LINE_MOT_FOOTER + (String::RC * 2)
  end

end #/TextAnalyzerOutputMotFormatTEXT
