# encoding: UTF-8
class Scrivener
class Project
  CHOSES = {
    'words'       => :mots,
    'mots'        => :mots,
    'prox'        => :proximites,
    'proxs'       => :proximites,
    'proximite'   => :proximites,
    'proximites'  => :proximites,
    'dist'        => :distances,
    'distance'    => :distances,
    'distances'   => :distances
  }

  SORT_TYPES = {
    alpha: t('sorted.alphabetically'), :'-alpha' => "#{t('sorted.alphabetically')} inverse",
    count: t('count.occurences').downcase,
    prox: t('count.proxs').downcase,
    dist:  t('distance.min.sing'), :'-dist' => t('distance.min.sing') + ' (inverse)'
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
      bads.empty? || rt('commands.show.errors.bads_to_show', {bads: bads.pretty_join})
      choses.any? || rt('commands.show.errors.nothing_to_show')
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
    CLI::Screen.clear
    choses.each do |dchose|
      chose_name    = dchose[0]
      chose_keysort = dchose[1]
      send("show_element_#{chose_name}".to_sym, chose_keysort)
    end
  end

  # ---------------------------------------------------------------------
  #   Pour créer l'entête de toutes les tables
  #
  LINES_ENTETE = ['', '', '   %{chose} '+' %{sort_type}', '', '']
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
      chose: t('proximity.tit.plur'), sort_type: SORT_TYPES[sorted_by],
      labels: "  #{t('index.tit.sing')} | #{"#{t('word.tit.sing')} %{nb_mots}".ljust(MOT_MAX_LEN)} "+
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

  # ---------------------------------------------------------------------
  # Affichage proximités

  LINE_PROXIMITE = '  %{id} | %{pmot} | %{nmot} | %{dist} |'
  def show_element_proximites(sorted_by)
    analyse.output.defaultize_options({sorted_by: sorted_by})
    header, separator = header_table_and_separator(
      chose: t('proximity.tit.plur'), sort_type: SORT_TYPES[sorted_by],
      labels: "  #{'Id'.rjust(5)} | #{t('word_before.tit').ljust(MOT_MAX_LEN)} | " +
        "#{t('word_after.tit').ljust(MOT_MAX_LEN)} | #{t('distance.abbr.tit').ljust(5)}|"
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

  # ---------------------------------------------------------------------
  #   Affichage distances
  LINE_DISTANCES = '    %{canon} | %{dist} |'
  def show_element_distances(sorted_by)
    TextAnalyzer::Analyse::TableResultats::Proximite.init(analyse)
    analyse.output.defaultize_options({sorted_by: sorted_by})
    header, separator = header_table_and_separator(
      chose: t('distance.tit.plur'), sort_type: SORT_TYPES[sorted_by],
      labels: "    #{t('word.tit.sing').ljust(MOT_MAX_LEN)} " +
        "| #{t('distance.abbr.tit').ljust(6)} |"
    )
    puts header
    analyse.output.sorted_list_mots.each_with_index do |dmot, index_mot|
      imot = analyse.mot(dmot.first)
      puts LINE_DISTANCES % {
        canon: imot.canon.ljust(MOT_MAX_LEN),
        dist:  imot.distance_minimale.to_i.to_s.ljust(6)
      }
    end
    puts separator
    puts String::RC * 3

  end
  # /show_element_distances

end #/Project
end #/Scrivener
