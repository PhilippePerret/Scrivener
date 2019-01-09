# encoding: UTF-8

# Module des helpers de TextAnalyzer::Analyse::TableResultats::Output
#
module TextAnalyzerOutputHelpers

  class TextAnalyzer::Analyse::TableResultats::Output
    def ecrit_date_analyse
      ls = ['']
      ls << CLI.separator(return: false, tab: '  ', char: '=').jaune
      ls << (INDENT*2 + analyse.title.upcase).jaune
      ls << INDENT*2 + t('analysis.cap.sing OF_date %s', [Time.now.to_i.as_human_date(true, true)]).jaune
      ls << ls[1]
      ls << ''
      ecrit ls.join(String::RC)
    end

    # Méthode principale qui retourne un entête complet pour une table
    # @usage :
    #   TextAnalyzer::Analyse::TableResultats::Output.table_full_header(...)
    def self.table_full_header args
      hlines = Array.new
      ltitre = '  « %{project_title} » : %{table_title}' % args
      hlines << ''
      hlines << ltitre.bleu
      hlines << '  ='.ljust(ltitre.length, '=').bleu
      hlines << ''
      hlines << CLI.separator(return: false, tab: '  ')
      if args.key?(:header_labels)
        hlines << args[:header_labels]
        hlines << CLI.separator(return: false, tab: '  ')
      end
      hlines.join(String::RC)
    end
  end #/ class Output

  def entete_table_nombres
    self.class.table_full_header({
      project_title:  analyse.title,
      table_title:    t('table.cap.sing of.cap.plur number.cap.plur')
      })
  end


  # ---------------------------------------------------------------------

  class TextAnalyzer::Analyse::TableResultats::Canon

    def outputClass
      @outputClass ||= TextAnalyzer::Analyse::TableResultats::Output
    end

    def header(options)
      @header ||= begin
        tbltitre = '%{des} %{canons} (%{sorteds} %{type_classement})' % {
          des: options[:limit] == Float::INFINITY ? t('all_the.cap') : ('%s %s' % [options[:limit], t('first.cap.plur')]),
          type_classement: self.class.classement_name(options),
          canons: t('canon.cap.plur'),
          sorteds: t('sorted.plur')
        }
        outputClass.table_full_header({
          project_title: analyse.title,
          table_title:   tbltitre,
          header_labels:  canons_header_labels
          })
      end
    end

    def canons_header_labels
      '   %s  |  %s  | %s |   %s  | %s |' % [
        t('canon.tit.sing').ljust(31),
        'x'. ljust(4),
        t('proximity.abbr.tit').ljust(5),
        ' % '.ljust(6),
        t('average.distance.tit').ljust(8)
      ]
    end

    def footer(options = nil)
      CLI.separator(return: false, tab: '  ')
    end

    def temp_line_canon
      @temp_line_canon ||= '   %{canon} | %{occ} |%{aster} %{proxs} | %{fdensite} | %{fmoydist} |'
    end

    # Ligne pour l'affichage d'un canon dans le format HTML
    def as_line_output index = nil
      temp_line_canon % {
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
        end.rjust(6)
      end
    end

    def formated_moyenne_distance
      @formated_moyenne_distance ||= begin
        moyenne_distances.to_s.rjust(8)
      rescue Exception => e
        '[CALC. ERR.: %s]' % e.message
      end
    end

  end #/class Canon

  # ---------------------------------------------------------------------

  class TextAnalyzer::Analyse::TableResultats::Proximite

    def outputClass
      @outputClass ||= TextAnalyzer::Analyse::TableResultats::Output
    end

    # Entête de la ligne d'affichage des proximités
    def header(options)
      tbltitre = '%{des} %{prox} (%{sorteds} %{type_classement})' % {
        des: options[:limit] == Float::INFINITY ? t('all_the.fem.cap') : ('%s %s' % [options[:limit], t('first.fem.cap.plur')]),
        type_classement: self.class.classement_name(options),
        prox: t('proximity.cap.plur'),
        sorteds: t('sorted.plur')
      }
      outputClass.table_full_header({
        project_title:  options[:analyse].title,
        table_title:    tbltitre,
        header_labels:  proximites_header_labels
      })
    end


    def proximites_header_labels
      INDENT+' %s | %s | %s | %s| %s | %s' % [
        ''                .ljust(5),
        'ID '             .ljust(8),
        t('word.tit.sing before')  .ljust(31),
        t('average.distance.abbr').ljust(5),
        t('word.tit.sing after')   .ljust(31),
        t('offset.tit.plur').ljust(16)
      ]
    end

    def temp_line_proximite
      @temp_line_proximite ||= '  %{findex}. | #%{fid} | %{pmot} | %{dist} | %{nmot} | %{foffsets}'
    end

    # Retourne la ligne à afficher pour la ligne de commande
    def as_line_output index = nil
       temp_line_proximite % {
        findex:   index.to_s.rjust(4),
        fid:      formated_id,
        pmot:     fprevmot,
        nmot:     fnextmot,
        dist:     fdistance,
        foffsets: foffsets
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

    def footer_line
      CLI.separator(return: false, tab: '  ')
    end
  end #/class Proximite

  # ---------------------------------------------------------------------

  class TextAnalyzer::Analyse::WholeText::Mot

    def outputClass
      @outputClass ||= TextAnalyzer::Analyse::TableResultats::Output
    end

    # Entête de la ligne d'affichage des proximités
    def header(options)
      tbltitre = '%{des} %{words} (%{sorteds} %{type_classement})' % {
        des: options[:limit] == Float::INFINITY ? t('all_the.cap') : ('%s %s' % [options[:limit], t('first.cap.plur')]),
        type_classement: self.class.classement_name(options),
        words: t('word.cap.plur'),
        sorteds: t('sorted.plur')
      }
      outputClass.table_full_header({
        project_title: analyse.title,
        table_title:   tbltitre,
        header_labels:  mots_header_labels
        })
    end

    def mots_header_labels
      '    %{index} | %{mot} | %{occ} | %{pindex} |' % {
        index:    t('index.tit.sing') .ljust(6),
        mot:      t('word.tit.sing')  .ljust(30),
        occ:      t('count.tit.sing') .ljust(7),
        pindex:   '% '       .rjust(8)
      }
    end

    def temp_line_mot
      @temp_line_mot ||= '    %{findex} | %{mot} | %{occs} | %{fpourc} | '
    end
    def as_line_output(index = nil)
      temp_line_mot % {
        findex:   index.to_s.rjust(6),
        mot:      self.real.ljust(30),
        occs:     nombre_occurences.to_s.ljust(7),
        fpourc:   fpourcentage.rjust(8)
      }
    end

    # Pourcentage d'utilisation du mot dans le texte
    # Par exemple, dans un texte constitué seulement de "Marion", le mot "marion"
    # aurait un pourcentage d'utilisation de 100%. Dans un texte constitué de
    # "Marion sourit", il aurait 50% d'utilisation.
    def fpourcentage
      '%s %%' % [pourcentage_utilisation.round(3).to_s]
    end

    def footer_line
      CLI.separator(return: false, tab: '  ')
    end

  end #/class Mot

end #/module TextAnalyzerOutputHelpers
