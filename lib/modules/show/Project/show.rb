# encoding: UTF-8
class Scrivener
  SHOW_ERRORS = {
    nothing_to_show: 'Aucun élément spécifié ne peut être affiché.',
    bads_to_show:    'Impossible d’afficher les éléments : %s.'
  }

class Project
  CHOSES = {
    'words'       => :mots,
    'mots'        => :mots,
    'prox'        => :proximites,
    'proxs'       => :proximites,
    'proximite'   => :proximites,
    'proximites'  => :proximites
  }

  SORT_TYPES = {
    alpha: 'ordre alphabétique', :'-alpha' => 'ordre alphabétique inverse',
    count: 'nombre d’occurences',
    prox: 'nombre de proximités',
    dist:  'distance', :'-dist' => 'distance (inverse)'
  }

  class << self

    def exec_show iprojet
      choses  = Array.new
      bads    = Array.new
      (1..10).each do |iparam|
        chose = CLI.params[iparam]  || break
        chose, sortkey = chose.split(':')
        chose = CHOSES[chose]       || begin
          bads << chose
          next
        end
        choses << [chose, (sortkey || :count).to_sym]
      end
      bads.empty? || raise(SHOW_ERRORS[:bads_to_show] % bads.pretty_join)
      choses.any? || raise(SHOW_ERRORS[:nothing_to_show])
      iprojet.show_elements(choses)
    rescue Exception => e
      puts e.message.rouge
      puts e.backtrace
    end
    # /exec_show

  end #/self

  # = main =
  #
  # Affichage des éléments +choses+
  def show_elements choses
    Scrivener.require_module('TextAnalyzer')
    get_data_analyse || return
    choses.each do |dchose|
      chose_name    = dchose[0]
      chose_keysort = dchose[1]
      send("show_element_#{chose_name}".to_sym, chose_keysort)
    end
  end

  # ---------------------------------------------------------------------
  #   Pour créer l'entête de toutes les tables
  #
  LINES_ENTETE = ['', '', '   %{chose}s classées par %{sort_type}', '', '']
  LINES_ENTETE << '__labels__'

  def header_table_and_separator data
    lines = LINES_ENTETE.dup
    lines[2] = lines[2] % data
    lines[1] = lines[3] = '  ='.ljust(lines[2].length + 1,'=')
    lines[5] = data[:labels] % data
    lines[2] = lines[2].upcase.jaune
    separator = '  -'.ljust(lines[5].length,'-')
    lines << separator
    return [lines.join(String::RC), separator]
  end

  # ---------------------------------------------------------------------
  # Affichage de tous les mots du texte
  #
  MOT_MAX_LEN = 20
  LINE_MOT = '  %{ind} | %{real} | %{count} | %{pct} %% | %{lemma} | %{canon} | %{proxs} |'
  def show_element_mots(sorted_by)
    analyse.output.defaultize_options({sorted_by: sorted_by})
    header, separator = header_table_and_separator(
      chose: 'Proximité', sort_type: SORT_TYPES[sorted_by],
      labels: "  Index | #{'Mot %{nb_mots}'.ljust(MOT_MAX_LEN)} "+
        "| #{'x'.rjust(4)} | #{'%%'.rjust(9)} " +
        "| #{'Lemma'.ljust(MOT_MAX_LEN)} " +
        "| #{'Canon'.ljust(MOT_MAX_LEN)} | #{'Prox.'.ljust(6)} |",
      nb_mots: ("(#{analyse.all_mots.count.to_s})").ljust(10)
    )
    puts header
    analyse.output.sorted_list_mots.each_with_index do |dmot, index_mot|
      imot = analyse.mot(dmot.first)
      puts LINE_MOT % {
        ind:    (index_mot + 1).to_s.rjust(5),
        real:   imot.real.ljust(MOT_MAX_LEN),
        count:  dmot[1].count.to_s.rjust(4),
        pct:    (dmot[1].count).pct(analyse.all_mots.count, 2).to_s.rjust(6),
        lemma:  imot.lemma.ljust(MOT_MAX_LEN),
        canon:  imot.canon.ljust(MOT_MAX_LEN),
        proxs:  imot.nombre_proximites.to_s.rjust(6)
      }
    end
    puts separator
    puts String::RC * 3
  end


  LINE_PROXIMITE = '  %{id} | %{pmot} | %{nmot} | %{dist} |'
  def show_element_proximites(sorted_by)
    analyse.output.defaultize_options({sorted_by: sorted_by})
    header, separator = header_table_and_separator(
      chose: 'Proximité', sort_type: SORT_TYPES[sorted_by],
      labels: "  #{'Id'.rjust(5)} | #{'Mot avant'.ljust(MOT_MAX_LEN)} | " +
        "#{'Mot après'.ljust(MOT_MAX_LEN)} | #{'Dist.'.ljust(5)}|"
    )
    puts header
    analyse.output.sorted_list_proximites.each do |iprox|
      puts LINE_PROXIMITE % {
        id: iprox.id.to_s.rjust(5),
        pmot: iprox.mot_avant.real.ljust(MOT_MAX_LEN),
        nmot: iprox.mot_apres.real.ljust(MOT_MAX_LEN),
        dist: iprox.distance.to_s.ljust(5)
      }
    end
    puts separator
    puts String::RC * 3
  end
  # /show_element_proximites

end #/Project
end #/Scrivener
