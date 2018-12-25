# encoding: UTF-8
module ModuleFormatageTdm


  class Scrivener::Project::BinderItem

    TDM_LINE_SIMPLE = '<div class="tdm-item__gris__"><span class="titre">%{ftitle}</span><span class="pagewri">%{fpage_by_wri}</span><span class="pageobj">%{fpage_by_obj}</span>'
    TDM_LINE        = TDM_LINE_SIMPLE + '<span class="sep">|</span><span class="signs_wri">%{fsigns}</span><span class="signs_obj">%{fobjectif}</span><span class="state">%{fstate}</span><span class="diff">%{fdiff}</span><span class="pages">%{fpages}</span><span class="cumul_pages">%{fcumul_pages}</span></div>'
    TDM_LINE_SIMPLE << '</div>'
    def template_line
      @tempate_line ||= CLI.options[:no_count] ? TDM_LINE_SIMPLE : TDM_LINE
    end

    # Le formatage final de la ligne
    def formate_line_when_text(line)
      line.sub(/__gris__/, self.text? ? '' : ' gris' )
    end

    def formated_title_line
      @formated_title_line ||= formated_title
    end

    def formated_page_by_objectif
      tdm.current_objectif.page.to_s
    end

    def formated_page_by_writing
      @formated_page_by_writing ||= tdm.current_size.page.to_s
    end

    def formated_state
      @formated_state ||= begin
        if objectif > 0
          '<span class="%s">◉</span><span class="%s">◉</span>' % [color_obj_reached, color_obj_too_big]
        else
          ''
        end
      end
    end
    # /formated_state

    # Ce n'est pas vraiment la différence, c'est la différence par rapport
    # à la valeur minimale (si pas objectif atteint) ou maximale (si objectif
    # dépassé) autorisée.
    def formated_diff
      @formated_diff ||= begin
        len = 6
        if diff_wri_obj
          ('<span class="%s">' % [diff_too_big? ? 'rouge' : 'vert']) +
          if diff_too_big?
            "#{overrun? ? '+' : '-'}#{unreached_or_overrun_value}"
          else
            "#{diff_wri_obj > 0 ? diff_wri_obj : - diff_wri_obj}"
          end + '</span>'
        else
          ''
        end
      end
    end
    # /formated_diff

    def formated_cumul_pages
      @formated_cumul_pages ||= tdm.current_size.pages_real_round.to_s
    end

  end #/Scrivener::Project::BinderItem

end#/Module
