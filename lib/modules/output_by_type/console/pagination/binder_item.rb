# encoding: UTF-8
module ModuleFormatageTdm
  class Scrivener::Project::BinderItem

    TDM_LINE        = '  %{ftitle}%{fpage_by_wri} | %{fpage_by_obj} |      %{fsigns} %{fobjectif} %{fstate} %{fdiff} %{fpages} %{fcumul_pages}'
    TDM_LINE_SIMPLE = '  %{ftitle}%{fpage_by_wri} | %{fpage_by_obj}'
    def template_line
      @tempate_line ||= CLI.options[:no_count] ? TDM_LINE_SIMPLE : TDM_LINE
    end

  end #/BinderItem
  end #/Project
  end #/Scrivener
end#/Module
