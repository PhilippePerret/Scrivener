# encoding: UTF-8
module ModuleFormatageTdm

  class Scrivener::Project::TDM

    # Méthode principale qui va sortir la table des matières dans le
    # format voulu.
    def output_table_of_content
      ecrit entete_fichier_html
      # Et pour le moment, on l'affichage comme ça
      ecrit lines.join(RET)
      ecrit footer_fichier_html
    ensure
      rf.close
    end

    def entete_fichier_html
      <<-HTML
<!DOCTYPE html>
<html lang="fr" dir="ltr">
  <head>
    <meta charset="utf-8">
    <title>#{projet.title} - #{t('table_of_contents.tit.sing')}</title>
    <style>#{css_styles}</style>
  </head>
  <body>
      HTML
    end
    def footer_fichier_html
      <<-HTML
</div><!-- div#tdm -->
<div class="footer">
  #{"(#{t('helps.notices.scriv_command', {cmd: CLI.command_init})})"}
</div>
</body></html>
      HTML
    end

    # Pour ajouter les lignes de titre
    def add_lines_titre
      lines << '<div class="titre">%s</div>' % [projet.title.upcase]
      lines << '<div class="stitre">#{t('table_of_contents.tit.sing')}</div>'
      lines << '<div class="infosdata">Produite le %s</div>' % [Time.now.to_i.as_human_date(false, true, {del_time: 'à'})]
      lines << '<div id="tdm">'
      lines << table_libelles
    end

    def table_libelles
      '<div class="labels tdm-item">' +
        '<span class="titre">'+t('titre.tit.sing')+'</span>' +
        '<span class="pagewri">'+t('numero.abbr.tit')+'<br>'+t('page.min.sing')+'</span>' +
        '<span class="pageobj">'+t('target.tit.sing')+'</span>' +
        '<span class="sep"></span>' +
        '<span class="signs_wri">'+t('written.min.sing')+'</span>' +
        '<span class="signs_obj">'+t('target.min.sing')+'</span>' +
        '<span class="state">'+t('state.min.sing')+'</span>' +
        '<span class="diff">diff.</span>' +
        '<span class="pages">'+t('unit.pages')+'</span>' +
        '<span class="cumul_pages">'+t('cumul.min.sing')+'</span>' +
      '</div>'
    end
    def css_styles
      <<-CSS
body {font-family: Arial;font-size: 16pt;}
div#tdm { margin-top: 2em;}
div#tdm div.labels {font-style:italic;opacity:0.6;font-size:0.65em;}
div.titre {font-size: 1.4em;}
div.stitre {font-size: 1.2em;}
div.infosdata {font-size: 0.6em;}
div.footer {font-size: 0.7em; margin-top: 2em;}
div.tdm-item {font-size: 0.9em;}
div.gris {opacity:0.4;}
div.gris:hover  {opacity:1;}
div.tdm-item > span {display: inline-block; font-size: 0.8em}
div.tdm-item.labels > span {text-align:center!important;}
div.tdm-item span.titre { width: 400px;}
div.tdm-item span.pagewri {width:50px;text-align:right;}
div.tdm-item span.pageobj {width:50px;text-align:right;}
div.tdm-item span.signs_wri {width: 100px; text-align: right; padding-right: 0.3em;}
div.tdm-item span.signs_obj { width: 100px;}
div.tdm-item span.state {width:40px;text-align:center;}
div.tdm-item span.state span.vert { color:green;}
div.tdm-item span.state span.rouge { color:red;}
div.tdm-item span.diff { width: 80px;}
div.tdm-item span.diff span.vert { color:green;}
div.tdm-item span.diff span.rouge { color:red;}
div.tdm-item span.pages {width:100px;text-align:center;}
div.tdm-item span.cumul_pages {width:100px;text-align:center;}
div.tdm-item span.sep { width: 20px; text-align: center;}
      CSS
    end



    def tdm_file_path
      @tdm_file_path ||= project.tdm_file_path('html')
    end

    def ecrit str
      rf.write str
    end

    def rf
      @rf ||= begin
        File.unlink(tdm_file_path) if File.exist?(tdm_file_path)
        File.open(tdm_file_path,'a+')
      end
    end


  end#/Scrivener::Project::TDM
end#/Module
