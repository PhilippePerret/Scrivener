# encoding: UTF-8
=begin
  Module pour la commande 'build'
  Méthode de l'instance Scrivener::Project
=end
module BuildDocumentsModule

OVERVIEW_BUILD_DOCUMENT = <<-EOT
#{t('commands.build.titles.built_tdm_overview')}
%{separation}
%{flabels}
%{separation}
%{lignes}
%{separation}
%{fspeccols}
EOT

  # {BuildingSettings} Instance des réglages de la construction des
  # documents.
  attr_accessor :building_settings
  attr_accessor :table_data
  attr_accessor :for_update
  # Liste des updates qui sont effectuées avec l'option --update (ou la
  # commande de même nom)
  attr_accessor :updates

  # Construction des documents du projet
  # Ou actualisation
  def exec_building
    CLI.debug_entry
    self.building_settings = BuildingSettings.new(self)
    self.for_update = !!CLI.options[:update]
    documents_params_are_valid_or_raise
    analyse_data_source
    search_target_column
    search_id_column
    search_metadatas_columns
    proceed_build_apercu unless for_update
    simulation? || begin
      if for_update
        ask_for_fermeture && proceed_update_documents
      else
        if confirm_all? && ask_for_fermeture
          proceed_build_documents
        end
      end
      finish_execution
    end
    CLI.debug_exit
  end

  # ---------------------------------------------------------------------

  def confirm_all?
    if building_settings.id_column
      building_settings.options[:create_id_metadata] = yesOrNo(t('documents.questions.create_id_metadata'))
    end
    if building_settings.target_column
      building_settings.options[:create_target_metadata] = yesOrNo(t('documents.questions.take_into_account_targets'))
    end
    CLI::Screen.clear
    puts building_settings.overview
    yesOrNo(t('questions.proceed_with_setup_above'))
  end
  # ---------------------------------------------------------------------

  # Vérifie qu'on ait bien toutes les données pour procéder à l'opération
  def documents_params_are_valid_or_raise
    building_settings.source_csv_exist? || begin
      # Différentes erreurs peuvent être produites en fonction des informations
      # données
      # Si aucun fichier n'a été fourni par --from
      if CLI.options[:from].nil?
        raise_source_default_unfoundable
      else
        raise_source_unfoundable(building_settings.source_csv_init)
      end
    end
    document_source_is_valide_or_raise
  end

  # Analyse du fichier de données et relève des informations
  def analyse_data_source
    proceed_each_line(procedure_simulation)
  end
  # On procède vraiment à l'opération de création des documents dans le
  # projet
  attr_accessor :last_folder_by_level
  attr_accessor :last_folder # {BinderItem}

  # Construction des documents, si ça n'est pas une simulation
  def proceed_build_documents
    # Pour garder la trace des containers courant
    self.last_folder_by_level = Hash.new
    self.last_folder_by_level.merge!(0 => self.binder_item(:draft_folder))
    self.last_folder = self.binder_item(:draft_folder)
    # TODO Si des éléments sont contenus, il faut signaler et préciser
    # qu'on fera seulement une actualisation, en gardant tous les
    # éléments voulus. Pour forcer une actualisation, il faut ajouter
    # l'option --force/-f
    proceed_each_line(procedure_real)

    # Créer (définit) la métadonnée ID générale et les méta-données si
    # nécessaire
    build_custom_metadatas

  end
  # /proceed_build_documents


  def build_custom_metadatas
    if building_settings.id_column || building_settings.metadatas_columns
      hmetadatas = Hash.new
      if building_settings.id_column
        hmetadatas.merge!('ID' => {'Title' => 'ID', 'Type' => :text})
      end
      if building_settings.metadatas_columns
        building_settings.metadatas_columns.each do |col_idx, col_name|
          hmetadatas.merge!(col_name => {'Title' => col_name, 'Type' => :text})
        end
      end
      # puts "--> hmetadatas: #{hmetadatas.inspect}"
      define_custom_metadatas_if_needed(hmetadatas)
    end
  end
  # /build_custom_metadatas

TABLE_MODIFICATIONS = '

%{header}
%{soulign}

'
  # Actualisation du projet
  def proceed_update_documents
    self.updates  = Array.new
    proceed_each_line(procedure_update)
    # Pour terminer, on affiche les actualisations opérées
    # puts "Nombre de modifications: #{updates.count}"

    header  = "  #{t('titles.summary_modifs_performed')} (#{updates.count})"
    sep     = '  -'.ljust(header.length,'-')
    puts TABLE_MODIFICATIONS % {
      header: header,
      soulign: sep
    }
    updates.each do |update|
      puts update.to_s(indent: '    ').send(update.update_ok ? :bleu : :rouge)
    end
    puts String::RC * 3
  end
  # /proceed_update_documents

  # Retourne true si l'update est possible
  def update_possible?
    # Pour pouvoir actualiser un projet, il faut :
    #   - que les documents soient identifiés (aient un ID => colonne ID)
    id_column_exist_pour_update_or_raise
  end
  # /update_possible?

  # Procédure qui construit pour de bon le document
  def procedure_real
    lambda do |line, idx_line|
      NewElement.new(
        self,
        self.last_folder,
        traite_ligne(line, idx_line)
        ).build
    end
  end
  # /procedure_real

  def procedure_update
    lambda do |line, idx_line|
      NewElement.new(
        self,
        self.last_folder,
        traite_ligne(line, idx_line)
        ).update
    end
  end
  # /procedure_update

  # Procédure de fin de la création
  def finish_execution
    self.xfile.save
  end
  # /finish_execution


  def proceed_each_line procedure
    idx_line = -1
    file_source.each_line.with_index do |line, index_real_line|
      line.strip.empty?     && next
      line.start_with?('#') && next
      idx_line += 1
      building_settings.heading? && idx_line < 1 && next # passer l'entête
      procedure.call(line, index_real_line)
    end
  end

  # On procède vraiment à l'opération
  def proceed_build_apercu
    # = Affichage de la table =
    apercu = OVERVIEW_BUILD_DOCUMENT
    separation = '   -'.ljust(building_settings.formated_labels.length + 2, '-')

    # Pour mettre des colonnes spéciales en pied de page
    formated_spec_cols = Array.new

    # Si une colonne pour l'objectif a été trouvée, on l'indique
    unless building_settings.target_column.nil?
      str = '%s%s: %s' % [t('column.targets'), FRENCH_SPACE, building_settings.target_column + 1]
      formated_spec_cols << INDENT*2 + str
    end
    if building_settings.id_column
      str = '%s%s: %s' % [t('column.ids'), FRENCH_SPACE, building_settings.id_column + 1]
      formated_spec_cols << INDENT*2 + str
    end

    unless formated_spec_cols.empty?
      formated_spec_cols << separation
      formated_spec_cols << String::RC * 2
      formated_spec_cols = formated_spec_cols.join(String::RC)
    end

    rf_temp.rewind
    puts apercu % { flabels:      building_settings.formated_labels,
                    separation:   separation,
                    lignes:       rf_temp.read,
                    fspeccols:    formated_spec_cols
                  }
  end

  def simulation?
    self.class.simulation == true
  end


  def procedure_simulation
    lambda do |line, idx_line|
      dline = traite_ligne(line, idx_line)
      dline_formated = dline.collect.with_index do |cell, col_idx|
        cell.ljust(table_data[col_idx][:max_len])
      end
      rf_temp.write(temp_line % dline_formated)
    end
  end

  def rf_temp
    @rf_temp ||= Tempfile.new('builddocuments')
  end

  def temp_line
    @temp_line ||= '    ' + Array.new(building_settings.cell_count, '%s').join('  |  ') + String::RC
  end

  # Vérifie que le document fourni soit valide, sinon produit une erreur
  def document_source_is_valide_or_raise
    source_csv_is_not_empty_or_raise
    # On passe chaque ligne du document en revue
    header_treated = false
    file_source.each_line.with_index do |line, idx_in_file|
      line.strip.empty?     && next
      line.start_with?('#') && next
      if !building_settings.heading? || header_treated
        control_ligne(line[0...-1], idx_in_file)
      elsif building_settings.heading?
        traite_ligne_entete(line.strip)
        header_treated = true
      end
    end
  end
  private :document_source_is_valide_or_raise

  def file_source
    File.new(building_settings.real_source_csv)
  end

  def table_data
    @table_data ||= define_table_data
  end


  # Contrôle de la ligne, pour voir si elle est valide et si on peut en
  # tirer des informations.
  def control_ligne lig, idx_in_file = nil
    dline = lig.split(building_settings.cell_delimitor, 1000) # 1000 pour ne pas supprimer les vides

    # Réglage du nombre de cellules (pour contrôler que chaque ligne
    # en possède le bon nombre)
    # On en profite aussi pour définir les labels par défaut

    if building_settings.cell_count.nil?
      # Le nombre de cellules n'a pas encore été établi (il pourrait l'être
      # avec les labels, qui sont traités avant).
      # On prend le nombre de cellule de cette première ligne de données.
      # S'il n'y a qu'une seule cellule, on produit une erreur de délimiteur
      dline.count > 1 || raise_delimitor_required
      building_settings.cell_count = dline.count
    else
      # Le nombre de cellules a déjà été défini, on vérifie que cette
      # ligne contienne le bon nombre de cellules
      bon_nombre_de_cellules_or_raise(idx_in_file, lig, dline)
    end

    # Contrôle de la présence des valeurs suffisantes pour définir
    # le titre du document. Si aucune profondeur n'est définie, la première
    # colonne doit impérativement contenir le titre du document.
    valeurs_par_depth_ok_or_raise(lig, idx_in_file + 1, dline)

    # On va chercher les longueurs max pour chaque colonne (juste pour
    # l'affichage)
    dline.each.with_index do |cell, idx|
      cell.strip!
      if ['m','w','p','s'].include?(cell[-1])
        ret = SWP.signs_from_human_value(cell)
        if ret.nil? # <= ce n'est pas une valeur d'objectif
          self.table_data[idx][:maybe_target] = false
        else
          cell = ret.to_s
        end
      elsif cell.to_s.empty?
        # On laisse cell telle quelle (ça n'empêche pas la colonne
        # de pouvoir être une colonne d'objectifs)
      elsif cell.match(/^[0-9\.]+$/)
        # Ça peut être une valeur pour un objectif, en nombre
        # de pages si c'est l'utité définie ou par défaut
        # Si une colonne a déjà été identifiée comme la colonne des
        # objectifs, on peut transformer la valeur
        if idx == building_settings.target_column
          cell = SWP.signs_from_human_value('%f%s' % [cell, building_settings.small_target_unit]).to_s
        end
      else
        # Dans le cas contraire, cette colonne ne peut pas être une
        # colonne définissant des objectifs
        self.table_data[idx][:maybe_target] = false
      end

      # On cherche la width max pour chaque colonne
      if self.table_data[idx][:max_len] < cell.length
        len = cell.length
        len < 40 || len = 40
        self.table_data[idx][:max_len] = len
      end

    end
  end
  # /control_ligne

  # Retourne la liste des cellules traitées
  def traite_ligne lig, idx_in_file = nil
    # ATTENTION : de pas tripper la ligne, elle se termine peut-être par
    # des tabulations en délimiteur
    dline = lig.split(building_settings.cell_delimitor, 1000) # 1000 pour ne pas supprimer les vides

    # puts "\n-- table_data: #{table_data.inspect}"

    # On en profite pour voir les longueurs max des cellules
    # Et on retourne la liste de cellule car la méthode sert aussi bien
    # pour le premier tour (relève et contrôle) que pour le second (traitement)
    dline.collect.with_index do |cell, idx|
      cell.strip!
      if ['m','w','p','s'].include?(cell[-1])
        ret = SWP.signs_from_human_value(cell)
        ret.nil? || cell = ret.to_s
      elsif cell.empty?
        # On laisse cell telle quelle
      elsif cell.match(/^[0-9\.]+$/)
        # Noter que ça peut être un nombre pour un objectif, avec l'unité
        # définie pour les objectifs (:page par défaut)
        if idx == building_settings.target_column
          cell = SWP.signs_from_human_value('%f%s' % [cell, building_settings.small_target_unit]).to_s
        end
      end
      cell
    end
  end
  # /traite_ligne

  # Traitement de la ligne d'entête (avec les labels) si elle est
  # founir
  def traite_ligne_entete line
    building_settings.labels = line.split(building_settings.cell_delimitor).collect{|l|l.strip}
    building_settings.labels.count > 1 || raise_delimitor_required
    building_settings.cell_count = building_settings.labels.count
    # On recherche éventuellement : la colonne des cibles, la colonne des ID numériques
    building_settings.labels.each_with_index do |label, idx|
      label.strip.match(/^(Target|Cible|Objectif)s?$/i) || next
      building_settings.target_column = idx
      break
    end
  end


  def bon_nombre_de_cellules_or_raise idx_in_file, lig, dline, nb_expected = nil
    nb_expected ||= building_settings.cell_count
    lig = "Lig.#{idx_in_file + 1} : #{lig}"
    dline.count == nb_expected || raise_bad_nombre_cellules(lig, dline.count, nb_expected)
  end


  # Retourne true si une colonne portant le nom 'id' a été trouvé
  # En fait, retourne l'index de la colonne.
  def search_id_column
    return if building_settings.labels.nil?
    building_settings.labels.each_with_index do |label, idx_label|
      if label.downcase == 'id'
        building_settings.id_column = idx_label
        break
      end
    end
  end

  # Méthode qui cherche une colonne pouvant définir les objectifs de
  # mots/pages/signes à atteindre (si elle n'a pas été trouvée par les labels).
  # Si deux colonnes candidates ont été trouvées, il faut que les
  # libellés les départagent.
  def search_target_column
    # puts "--> search_target_column(building_settings.target_column=#{building_settings.target_column.inspect})"
    return if building_settings.target_column != nil
    table_data.each do |idx_col, dcol|
      if dcol[:maybe_target] && idx_col != building_settings.id_column
        if building_settings.target_column
          # Une colonne des cibles avait déjà été trouvée. Il n'y a pas
          # de labels donc on peut relever une erreur tout de suite
          raise_double_colonnes_target
        end
        building_settings.target_column = idx_col
      end
    end
  end
  # /search_target_column
  private :search_target_column

  # Méthode qui cherche les colonnes pouvant définir des métadatas
  # Le but est d'obtenir une table :
  #   {
  #     <index colonne>: "<label>"
  #   }
  def search_metadatas_columns
    # S'il n'y a pas de labels, il ne peut pas y avoir de métadonnées
    building_settings.labels || return
    # Toutes les colonnes
    metadatas_columns = Hash.new
    building_settings.labels.each_with_index {|label, idx| metadatas_columns.merge!(idx => label)}

    # On passe les colonnes de profondeur
    (building_settings.depth||1).times{|itime| metadatas_columns.delete(itime) }
    # On passe les colonnes des ID et Target si elles sont définies
    building_settings.id_column && metadatas_columns.delete(building_settings.id_column)
    building_settings.target_column && metadatas_columns.delete(building_settings.target_column)
    # On ne garde que les colonnes restantes
    building_settings.metadatas_columns = metadatas_columns
  end
  # /search_metadatas_columns
  private :search_metadatas_columns

  def source_csv_is_not_empty_or_raise
    File.stat(building_settings.real_source_csv).size > 0 || raise_empty_document_source(building_settings.source_csv_init)
  end
  private :source_csv_is_not_empty_or_raise

  def define_table_data
    # S'il n'y avait pas de première ligne de label, il faut
    # construire table_data
    h = Hash.new
    building_settings.cell_count.times do |itime|
      maxlen =
        if building_settings.labels
          building_settings.labels[itime].to_s.length
        else
          0
        end
      h.merge!(itime => {
        max_len:      maxlen,
        maybe_target: true # pour indiquer que ça peut être la colonne target
      })
    end
    return h
  end
  private :define_table_data

  # Si une profondeur est définie, on ne doit trouver qu'une et une
  # seule valeur doit les <profondeur> premières colonnes.
  # trouvée dans les x première cellules, soit aucune profondeur
  # n'est définie et la première colonne doit comprendre une valeur
  def valeurs_par_depth_ok_or_raise(lig, idx_in_file, dline)
    if building_settings.depth == 1 # valeur par défaut
      raise_depth_required if dline[0].strip.empty?
    else
      une_valeur_deja_definie = false
      (0...building_settings.depth).each do |ival|
        val = dline[ival].strip
        next if val.empty?
        if une_valeur_deja_definie
          # Il ne peut pas y avoir deux valeurs définies à deux niveaux
          # de profondeur différents
          puts "\n\nERROR(double value): #{lig}::#{idx_in_file}"
          raise_double_value_profondeur(lig, idx_in_file)
        else
          une_valeur_deja_definie = true
        end
      end
    end
  end
  # /valeurs_par_depth_ok_or_raise
  private :valeurs_par_depth_ok_or_raise

end#/module
