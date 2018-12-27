# encoding: UTF-8
module ModuleFormatageTdm

  class Scrivener::Project::BinderItem

    TDM_LINE        = '  %{ftitle}%{fpage_by_wri} | %{fpage_by_obj} |      %{fsigns} %{fobjectif} %{fstate} %{fdiff} %{fpages} %{fcumul_pages}'
    TDM_LINE_SIMPLE = '  %{ftitle}%{fpage_by_wri} | %{fpage_by_obj}'

    # BOULE = '•'
    # BOULE = '◦'
    BOULE = '●'
    BOULE_OK = '✅'
    BOULE_KO = '🛑'

    # ○◦✡︎▵■●☐⦁❌⭕️❗️‼️

    def template_line
      @tempate_line ||= CLI.options[:no_count] ? TDM_LINE_SIMPLE : TDM_LINE
    end

    # Le formatage final de la ligne
    def formate_line_when_text(line)
      self.text? ? line : line.gris
    end

    def formated_title_line
      @formated_title_line ||= "#{formated_title} ".ljust(tdm.title_width + 5, '.')
    end

    def formated_page_by_objectif
      tdm.current_objectif.page.to_s.rjust(tdm.obj_page_number_width + 1)
    end

    def formated_page_by_writing
      @formated_page_by_writing ||= (' '+tdm.current_size.page.to_s).rjust(tdm.wri_page_number_width + 1,'.')
    end

    def boule_ok

    end

    def mark_objectif_reached
      @mark_objectif_reached ||= begin
        BOULE.send(color_obj_reached)
        # objectif_reached? ? BOULE_OK : BOULE_KO
      end
    end
    def mark_objectif_too_big
      @mark_objectif_too_big ||= begin
        BOULE.send(color_obj_too_big)
        # diff_too_big? ? BOULE_KO : BOULE_OK
      end
    end
    def formated_state
      @formated_state ||= begin
        if objectif > 0
          mark_objectif_reached + mark_objectif_too_big
        else
          ''.ljust(2)
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
          if diff_too_big?
            "#{overrun? ? '+' : '-'}#{unreached_or_overrun_value}".ljust(len).rouge
          else
            "#{diff_wri_obj > 0 ? diff_wri_obj : - diff_wri_obj}".ljust(len).vert
          end
        else
          ''.ljust(6)
        end
      end
    end
    # /formated_diff

    def formated_cumul_pages
      @formated_cumul_pages ||= tdm.current_size.pages_real_round.to_s.rjust(10)
    end

  end #/Scrivener::Project::BinderItem


end#/Module
