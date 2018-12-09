class Scrivener
class Project

  # = main =
  #
  # Méthode principale affichant toutes les données possibles du
  # projet courant.
  def output_data options = nil
    tbl = TableauConsole.new(self, self.tableau_proximites, :table_proximites)
    tbl.build_and_display
  end

  # ---------------------------------------------------------------------
  #   Méthodes utilitaire

  def nombre_pages by
    case by
    when :mots
      @pages_by_mots ||= ((self.segments.count / 2).to_f / String::NOMBRE_MOTS_PAGE).round + 1
    when :chars
      @pages_by_chars ||= (self.longueur_whole_texte / String::PAGE_WIDTH).round + 1
    when :moyen
      @nb_pages_moyen ||= (nombre_pages(:mots) + nombre_pages(:chars)) / 2
    end
  end
  def nombre_total_proximites
    @nombre_total_proximites ||= tableau_proximites[:proximites].count
  end
  # Le pourcentage de proximités par rapport au nombre de canon.
  def human_pct_proximites_canons
    @human_pct_proximites_canons ||= pourcentage_proximites_canons.pourcentage
  end
  def pourcentage_proximites_canons
    @pourcentage_proximites_canons ||= (nombre_canons_avec_proximites.to_f / nombre_total_canons)
  end
  # Rapport au nombre de canons avec proximités et sans
  def rapport_canons_avec_sans_proximites
    @rapport_canons_avec_sans_proximites ||= begin
      (nombre_canons_avec_proximites.to_f / nombre_canons_sans_proximites).pretty_round
    end
  end
  def canons_avec_proximites
    @canons_avec_proximites ||= define_canons_sans_avec_proxs(:avec)
  end
  def canons_sans_proximites
    @canons_sans_proximites ||= define_canons_sans_avec_proxs(:sans)
  end
  def canons_sorted_by_proximites
    @canons_sorted_by_proximites ||= define_canons_sans_avec_proxs(:sorted)
  end
  def canons_sorted_by_occurences
    @canons_sorted_by_occurences ||= begin
      self.tableau_proximites[:mots].sort_by do |canon, dcanon|
        - dcanon[:items].count
      end
    end
  end
  # Le +from+ sert juste à savoir quelle liste doit être
  # retournée, pour simplifier l'écriture des listes ci-dessus
  def define_canons_sans_avec_proxs(from)
    # On boucle sur tous les mots pour :
    #   1. Connaitre les plus grandes fréquences
    #   2. Connaitre le nombre de mots qui ont une trop grande proximités
    avec_list = Array.new
    sans_list = Array.new
    sorted_list =
      self.tableau_proximites[:mots].sort_by do |canon, dcanon|
        if dcanon[:proximites].empty?
          sans_list << canon
        else
          avec_list << canon
        end
        - dcanon[:proximites].count
      end
    @canons_avec_proximites       = avec_list
    @canons_sans_proximites       = sans_list
    @canons_sorted_by_proximites  = sorted_list
    case from
    when :avec    then avec_list
    when :sans    then sans_list
    when :sorted  then sorted_list
    end
  end
  # /define_canons_sans_avec_proxs
  def nombre_total_canons
    @nombre_total_canons ||= tableau_proximites[:mots].count
  end
  # Nombre de mots (canon) qui sont en proximités
  def nombre_canons_avec_proximites
    @nombre_canons_with_proximites ||= canons_avec_proximites.count
  end
  def nombre_canons_sans_proximites
    @nombre_canons_sans_proximites ||= canons_sans_proximites.count
  end
  # Nombre maximum. 'après' et 'après' valent pour 2 mots
  def nombre_total_mots
    @nombre_total_mots ||= self.segments.count / 2
  end
  # Nombre de mots différents
  # 'après' et 'après' valent pour un seul mot
  def nombre_total_real_mots
    @nombre_total_real_mots ||= begin
      tableau_proximites[:real_mots].count
    end
  end

  def sorted_real_mots_by_occurences
    @sorted_real_mots_by_occurences ||= begin
      # puts "--- segments: #{segments.inspect}"
      tableau_proximites[:real_mots].collect do |m, arr|
        # On prend le premier terme pour voir ce que c'est, et notamment
        # pour s'assurer que c'est un mot, et pas un intermot
        dmot = segments[arr.first]
        # puts "mot: #{m.inspect} / segment : #{dmot.inspect}"
        if dmot[:type] == :mot && !dmot[:new_document_title]
          [m, arr]
        else
          # puts "==> On ne traite pas #{m.inspect}"
          nil
        end
      end.compact.sort_by do |m, arr|
        - arr.count
      end
    end
  end
  # Calcul du taux de différence qui correspond au nombre de mots différents
  # par rapport au nombre de mots total.
  # Par exemple, si le texte comporte 100 mots et que ces 100 mots sont tous
  # différents, le texte a un taux de différence de 100%
  # En revanche, si le texte comporte 100 mots et que ces 100 mots sont semblables,
  # le taux de différence et de 0%
  def taux_difference_mots
    @taux_difference_mots ||= begin
      (100 * (nombre_total_real_mots.to_f / nombre_total_mots)).pretty_round
    end
  end
  def longueur_whole_texte
    @longueur_whole_texte ||= File.stat(whole_text_path).size
  end

  # Méthode qui calcule la moyenne d'éloignement, c'est-à-dire la distance
  # moyenne entre les mots lorsqu'ils sont en proximité (et seulement lorsqu'ils
  # sont en proximité).
  #
  # Note : cette méthode permet
  def moyenne_eloignements
    @moyenne_eloignements || calcule_proximites_variable_et_moyenne_distance
    @moyenne_eloignements
  end

  def proximites_par_tranche
    @proximites_par_tranche || calcule_proximites_variable_et_moyenne_distance
    @proximites_par_tranche
  end

  # Méthode qui calcule la moyenne d'éloignement, mais aussi le nombre
  # de proximités suivant les tranches (à 250 mots, 500 mots, 750 mots, etc.)
  def calcule_proximites_variable_et_moyenne_distance
    puts "--> calcule_proximites_variable_et_moyenne_distance"
    total_distances = 0
    # Le total des distances, mais seulement pour les mots qui
    # sont à distance normale maximale (1 page)
    total_distances_common = 0
    @proximites_par_tranche = {
      250   => {all: 0, common: 0},
      500   => {all: 0, common: 0},
      750   => {all: 0, common: 0},
      1000  => {all: 0, common: 0},
      1250  => {all: 0, common: 0},
      1500  => {all: 0, common: 0}
    }
    tableau_proximites[:proximites].each do |prox_id, iprox|
      is_distance_normale = iprox.distance_minimale == Proximite::DISTANCE_MINIMALE
      total_distances += iprox.distance
      tranche = ((iprox.distance / 250) + 1) * 250
      @proximites_par_tranche[tranche][:all] += 1
      if is_distance_normale
        total_distances_common += iprox.distance
        @proximites_par_tranche[tranche][:common] += 1
      end
    end
    @moyenne_eloignements = (total_distances / nombre_total_proximites)
    @moyenne_eloignements_common = (total_distances_common / nombre_total_proximites)
  end

  # ---------------------------------------------------------------------
  # Classe pour construire le tableau

  class TableauConsole

    LINETBL_LABEL_WITDH = 36
    LINETBL_VALUE_WIDTH = 10
    TAB = '  '
    RC  = String::RC
    SEP = String.console_delimitor + RC*2

    attr_accessor :tableau_resultat
    # La table contenant les textes d'aide décrivant notamment ce que
    # signifie chaque donnée
    attr_accessor :tableau_aide

    # Instance {Scrivener::Project} du projet du tableau
    attr_accessor :projet
    # Instance {Hash} des données à afficher et {Symbol} type du tableau
    # Type peut être :proximites (seulement ça pour le moment)
    attr_accessor :tableau, :type

    attr_accessor :options

    def initialize iprojet, tableau, type_tableau, options = nil
      self.projet   = iprojet
      self.tableau  = tableau
      self.type     = type_tableau
      self.options  = options
    end

    # = main =
    #
    # Construit le tableau (ou le récupère d'un fichier) et l'affiche
    #
    # Noter que pour être uptodate?, le tableau doit exister.
    #
    def build_and_display
      (uptodate? && !CLI.options[:update]) ? load : build_and_save
      display
    end

    # Méthode principale qui construit le tableau des résultats et les
    # affiche.
    def build_and_save
      Proximite.init # initialiser les listes
      build
      save
    end
    # = main =
    #
    # Construction du tableau (en fonction de son type)
    # Le type peut être : :nombre (nombre de proximités, de mots canoniques,
    # etc, toutes données tirées du tableau_proximites)
    #
    def build
      puts "--> Construction de la vue des données…"
      self.tableau_resultat = Array.new
      self.tableau_aide     = Array.new
      tableau_resultat << SEP
      self.send(('build_%s' % self.type).to_sym)
      self.tableau_resultat = tableau_resultat.join(RC) + SEP + tableau_aide.join(RC)
    end

    # Affiche le tableau des résultats
    def display
      tableau_resultat.is_a?(Array) && self.tableau_resultat = tableau_resultat.join(RC)
      puts tableau_resultat
    end

    def save
      # puts "--> save (in #{path})"
      File.unlink(path) if File.exist?(path)
      File.open(path,'wb'){ |f| f.write(self.tableau_resultat)}
    end
    def load
      puts '--> Je recharge le dernier tableau enregistré (pour l’actualiser, ajouter l’option --update)'.bleu
      sleep 2
      self.tableau_resultat = File.read(path)
    end

    # ---------------------------------------------------------------------
    #   MÉTHODES D'HELPER

    # Note : normalement, c'était une méthode de Scrivener::Project
    # +options+
    #     :color        Couleur pour la valeur, une méthode de String
    #     :llength      Largeur du label, LINETBL_LABEL_WITDH par défaut
    #     :after_value  Texte à mettre après la valeur (pour la préciser)
    #
    def line label, value, options = nil
      options ||= Hash.new
      label_length = options[:llength] || LINETBL_LABEL_WITDH
      fvalue = value.to_s.rjust(LINETBL_VALUE_WIDTH)
      options[:after_value] && fvalue << options[:after_value]
      options[:color] && fvalue = fvalue.send(options[:color])
      tableau_resultat << TAB + '%s : %s' % [label.ljust(label_length), fvalue]
    end

    # Méthode pour ajouter un titre au tableau
    def titre str, sous_str = nil, options = nil
      tableau_resultat << RC*2
      tableau_resultat << SEP
      tableau_resultat << TAB + str
      tableau_resultat << TAB + ('–' * str.length)
      sous_str && tableau_resultat << TAB + sous_str
      tableau_resultat << RC
    end

    def build_table_proximites
      line('Nombre total de signes %s' % [1.to_expo], projet.longueur_whole_texte, {after_value: ' signes'})
      tableau_aide << '(1) C’est la longueur en nombre de signes, ponctuations et espaces comprises.'
      line('Nombre total de mots %s' % [3.to_expo], projet.nombre_total_mots, {after_value: ' mots'})
      tableau_aide << '(3) C’est vraiment le nombre de mots dans le texte.'
      line('Nombre pages suivant signes %s' % [2.to_expo], projet.nombre_pages(:chars))
      tableau_aide << '(2) C’est le nombre de pages d’après le nombre de caractères (%i par page).' % String::PAGE_WIDTH
      line('Nombre pages suivant mots %s' % [4.to_expo], projet.nombre_pages(:mots))
      tableau_aide << '(4) C’est le nombre de pages en fonction du nombre de mots (%i mots par pages).' % String::NOMBRE_MOTS_PAGE
      line('Nombre pages estimé %s' % [5.to_expo], projet.nombre_pages(:moyen), {after_value: ' pages', color: :bleu})
      tableau_aide << '(5) Nombre estimé en fonction du nombre de pages suivant les signes et du nombre de pages suivant les mots.'
      line('Nombre de mots différents %s' % [7.to_expo], projet.nombre_total_real_mots, {color: :bleu})
      line('Nombre de mots canoniques %s' % [6.to_expo], projet.nombre_total_canons)
      tableau_aide << '(6) Les mots canoniques sont les formes de base d’un mot. Par exemple, le mot au singulier quand c’est un pluriel (« yeux » -> « œil ») ou l’infinitif quand c’est un verbe (« pris » -> « prendre »).'
      tableau_aide << '(7) Dans ce compte, deux mots identiques valent 1 occurence (contrairement à %s), mais deux mots de même forme canonique (« pris » et « prenais ») valent deux occurences, contrairement à %s.' % [3.to_expo, 6.to_expo]
      line(' => Taux de différence %s' % [8.to_expo], projet.taux_difference_mots, {after_value: ' %'})
      tableau_aide << ('(8) Nombre de mots différents en fonction du nombre de mots total. Plus ce taux est élevé, plus le texte présente de variété de mots.')
      line('NOMBRE TOTAL DE PROXIMITES %s' % [9.to_expo], projet.nombre_total_proximites, {color: :rouge})
      tableau_aide << '(9) C’est le nombre absolu dans le texte.'
        projet.proximites_par_tranche.each do |tranche, dnombre|
          line('    Nombre proximités <= %i signes' % tranche, "#{dnombre[:all]} | #{dnombre[:common]}", {llength: 44})
        end
      long_label = 40
      # TODO Rapport entre le nombre de canons et le nombre de mot différent
      # plus ce nombre est grand, plus les mots sont différents
      line('Moyenne éloignement %s' % [14.to_expo], projet.moyenne_eloignements, {llength: long_label, after_value: ' signes'})
      tableau_aide << '(14) C’est l’éloignement moyen entre deux mots lorsqu’ils sont en proximité (et seulement lorsqu’ils sont en proximité).'
      line('Nombre de canons avec proximités %s' % [10.to_expo], projet.nombre_canons_avec_proximites, {color: :rouge, llength: long_label})
      line('Nombre de canons sans proximités %s' % [11.to_expo], projet.nombre_canons_sans_proximites, {color: :bleu, llength: long_label})
      line('Pourcentage de canons en proximité %s' % [12.to_expo], (100 * projet.pourcentage_proximites_canons).pretty_round(1), {llength: long_label, after_value: ' % des canons sont en proximité', color: (projet.pourcentage_proximites_canons > 0.5 ? :rouge : :bleu)} )
      tableau_aide << ('(12) Par rapport au nombre de canons, le nombre de proximités pour ces canons. Si tous les canons sont en proximité, le nombre est 100 %, si aucun canon n’est en proximité (pas de proximités), le nombre est 0 %. Plus ce pourcentage est petit, meilleur est ce texte.')
      line('Rapport canons avec/sans prox. %s' % [13.to_expo], projet.rapport_canons_avec_sans_proximites, {llength: long_label})
      tableau_aide << '(13) Ce nombre est de 1 lorsqu’il y a autant de canons sans proximité que de canons avec. La meilleure valeur est 0 (=> aucune proximité).'

      tableau_resultat << RC

      # Liste des canons les plus en proximité
      build_liste_canons
      # Liste des canons les plus fréquents
      build_liste_canons_les_plus_utilised
      # Liste des mots les plus fréquents
      build_liste_real_mots
    end

    # Construction de la liste des canons pour le projet courant
    #
    # Le nombre est 50 par défaut, affichés sur deux colonnes grâce à la
    # méthode Array#face_a_face({:width, :gutter})
    def build_liste_canons
      sous_titre = '(canon | occurences | nb proximités | % de proximités | moyenne d’éloignement ||)'
      titre('Liste des 50 mots les plus en proximité', sous_titre)

      left_canons   = projet.canons_sorted_by_proximites[0...25]
      right_canons  = projet.canons_sorted_by_proximites[25...50]
      left_canons.each_with_index do |dlcanon, indexcanon|
        ilcanon = Canon.new(self, dlcanon.first, dlcanon[1])
        drcanon = right_canons[indexcanon]
        ircanon = Canon.new(self, drcanon.first, drcanon[1])
        tableau_resultat << [ilcanon.line_demi_colonne, ircanon.line_demi_colonne].face_to_face
      end
      tableau_resultat << RC
    end

    def build_liste_canons_les_plus_utilised
      titre('Liste des 50 mots canoniques les plus fréquents')
      left_canons   = projet.canons_sorted_by_occurences[0...25]
      right_canons  = projet.canons_sorted_by_occurences[25...50]
      left_canons.each_with_index do |dlcanon, indexcanon|
        ilcanon = Canon.new(self, dlcanon.first, dlcanon[1])
        drcanon = right_canons[indexcanon]
        rdemiline = nil
        if drcanon
          ircanon = Canon.new(self, drcanon.first, drcanon[1])
          rdemiline = ircanon.line_demi_colonne
        else
          rdemiline = ''
        end
        tableau_resultat << [ilcanon.line_demi_colonne, rdemiline].face_to_face
      end
      tableau_resultat << RC
    end

    def build_liste_real_mots
      titre('Liste des 50 mots de plus de trois lettres les plus fréquents')
      nombre_mots = 0
      array_mots  = Array.new
      projet.sorted_real_mots_by_occurences.each do |mot, indexes|
        mot.length > 3 || next
        array_mots << '%s. %s %s' % [(nombre_mots + 1).to_s.rjust(2), mot.ljust(20), indexes.count.to_s.rjust(6)]
        nombre_mots += 1
        break if nombre_mots >= 50
      end
      left_list   = array_mots[0...25]
      right_list  = array_mots[25...50]

      left_list.each_with_index do |ldmot, indexmot|
        rdmot = right_list[indexmot] || ['', '']
        tableau_resultat << [ldmot, rdmot].face_to_face
      end

      tableau_resultat << RC

    end
    # /build_liste_real_mots

    # ---------------------------------------------------------------------
    #   Méthodes pratiques

    def vue_exist?
      File.exists?(path)
    end

    # Retourne true si le tableau construit est plus vieux
    # que la donnée enregistrée.
    # Attention, pour le moment, on considère le tableau de proximité
    # alors qu'il pourrait s'agir d'une autre donnée. En fait, pour le
    # moment, on ne connait pas le path des données qu'on prend et c'est
    # ça qu'il faudrait transmettre à l'instanciation (TODO)
    def uptodate?
      # puts "== vue_exist? est #{vue_exist?.inspect}"
      # puts "== File.stat(path).mtime (#{File.stat(path).mtime}) > File.stat(projet.path_proximites).mtime (#{File.stat(projet.path_proximites).mtime}) est #{(File.stat(path).mtime > File.stat(projet.path_proximites).mtime).inspect}"
      vue_exist? && File.stat(path).mtime > File.stat(projet.path_proximites).mtime
    end

    # Chemin d'accès à ce tableau construit (if any)
    def path
      @path ||= File.join(projet.hidden_folder, 'vue_%{type}%{all}.txt' % {type: self.type, all: (CLI.options[:all] ? '_all' : '')})
    end

  end #/TableauConsole

end #/Project
end #/Scrivener
