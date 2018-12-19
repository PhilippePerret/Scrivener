# encoding: UTF-8

# Module des helpers de TextAnalyzer::Analyse::TableResultats::Output
#
module TextAnalyzerOutputHelpersFormatTEXT

  # Fonctionne pour :
  # class TextAnalyzer::Analyse::TableResultats::Output
  LINE_NOMBRE_ENTETE = Array.new

  def entete_table_nombres
    titre_nombre_entete = '  « %s » : TABLE DES NOMBRES' % [analyse.title.titleize]
    LINE_NOMBRE_ENTETE << ''
    LINE_NOMBRE_ENTETE << ''
    LINE_NOMBRE_ENTETE << titre_nombre_entete.bleu
    LINE_NOMBRE_ENTETE << '  ='.ljust(titre_nombre_entete.length,'=').bleu
    LINE_NOMBRE_ENTETE << ''
    LINE_NOMBRE_ENTETE << CLI.separator(return: false)
    LINE_NOMBRE_ENTETE.join(String::RC)
  end

end #/TextAnalyzerOutputHelpersFormatTEXT

# Module des méthodes pour CANON
module TextAnalyzerOutputCanonFormatTEXT

  TITRE_LISTING = '  « %{title} » – %{des} CANONS (classés %{type_classement})'
  LINE_CANON_ENTETE = Array.new
  LINE_CANON_ENTETE << ''
  LINE_CANON_ENTETE << '<calculé plus tard suivant classement>'
  LINE_CANON_ENTETE <<  '='
  LINE_CANON_ENTETE << ''
  LINE_CANON_ENTETE << '  %s | %s | %s | %s | %s |' % [
    ' Canon '.ljust(31),
    ' x '. ljust(4),
    'Prox.'.ljust(5),
    ' % '.ljust(5),
    'Dist.moy'.ljust(8)
  ]
  LINE_CANON_ENTETE << '-' * LINE_CANON_ENTETE[4].length


  def header(options)
    titre_listing = TITRE_LISTING % {
      title: analyse.title.titleize,
      des: options[:limit] == Float::INFINITY ? 'TOUS LES' : ('%s PREMIERS' % options[:limit]),
      type_classement: self.class.classement_name(options)
    }
    LINE_CANON_ENTETE[1] = titre_listing.bleu
    LINE_CANON_ENTETE[2] = '  ='.ljust(titre_listing.length, '=').bleu
    LINE_CANON_ENTETE.join(String::RC)
  end

  def footer(options = nil)
    LINE_CANON_ENTETE[5]
  end


  LINE_CANON = '   %{canon} | %{occ} |%{aster} %{proxs} | %{fdensite} | %{fmoydist} |'
  # Ligne pour l'affichage d'un canon dans le format HTML
  def as_line_output index = nil
    LINE_CANON % {
      canon:      fcanon,
      occ:        foccurences,
      proxs:      fproxs,
      aster:      (distance_minimale != TextAnalyzer::DISTANCE_MINIMALE ? '*' : ' '),
      fdensite:   formated_densite,
      fmoydist:   formated_moyenne_distance
    }
  end

  def fcanon
    @fcanon ||= self.canon.ljust(30)
  end

  def foccurences
    @foccurences ||= nombre_occurences.to_s.rjust(4)
  end

  def foffsets
    @foffsets ||= self.mots.collect{|m|m.offset}.join(', ')
  end

  # nombre de proximités dans ce canon
  def fproxs
    @fproxs ||= begin
      (nombre_proximites > 0 ? nombre_proximites.to_s : '-').rjust(4)
    end
  end

  def formated_densite
    @formated_densite ||= begin
      if nombre_proximites > 0
        (nombre_proximites.to_f / nombre_occurences).pourcentage
      else
        ' - '
      end.rjust(5)
    end
  end

  def formated_moyenne_distance
    @formated_moyenne_distance ||= begin
      moyenne_distances.to_s.rjust(8)
    rescue Exception => e
      '[ERR. CALC: %s]' % e.message
    end
  end

  def nombre_proximites
    @nombre_proximites ||= self.proximites.count
  end
  def nombre_occurences
    @nombre_occurences ||= self.mots.count
  end

end #/module TextAnalyzerOutputFormatTEXT

# Méthode pour les PROXIMITÉS
module TextAnalyzerOutputProximiteFormatTEXT

  TITRE_LISTING = '  « %{title} » – %{des} PROXIMITÉS (classés %{type_classement})'
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
    titre = TITRE_LISTING % {
      title: analyse.title.titleize,
      des: options[:limit] == Float::INFINITY ? 'TOUTES LES' : ('%s PREMIÈRES' % options[:limit]),
      type_classement: self.class.classement_name(options)
    }
    LINE_PROXIMITE_ENTETE[1] = titre.bleu
    LINE_PROXIMITE_ENTETE[2] = '  ='.ljust(titre.length,'=').bleu
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

  TITRE_LISTING = '  « %{title} » – %{des} MOTS (classés %{type_classement})'
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
    titre = TITRE_LISTING % {
      title: analyse.title.titleize,
      des: options[:limit] == Float::INFINITY ? 'DE TOUS LES' : ('DES %s PREMIERS' % options[:limit]),
      type_classement: self.class.classement_name(options)
    }
    LINE_MOT_ENTETE[1] = titre.bleu
    LINE_MOT_ENTETE[2] = '  ='.ljust(titre.length, '=').bleu
    LINE_MOT_ENTETE.join(String::RC)
  end
  def footer_line
    LINE_MOT_FOOTER + (String::RC * 2)
  end

end #/TextAnalyzerOutputMotFormatTEXT
