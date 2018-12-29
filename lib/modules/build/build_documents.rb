# encoding: UTF-8
=begin
  Module pour la commande 'build'
=end
module BuildDocumentsModule

  attr_accessor :src_document
  attr_accessor :cell_delimitor
  attr_accessor :cell_count # Nombre de cellules dans la première ligne analysée
  attr_accessor :labels
  attr_accessor :table_data
  # {Fixnum} Indice 0-start de la colonne définissant les
  # objectifs, if any. Et colonne définissant l'identifiant
  attr_accessor :target_column, :id_column
  # {Hash} Options de construction
  # Contient notamment :ids qui est mis à true si des identifiants sont
  # définis et qu'il faut créer cette métadonnée et :targets si des objectifs
  # sont définis et qu'il faut les régler.
  attr_accessor :building_options

OVERVIEW_BUILD_DOCUMENT = <<-EOT


APERÇU DE LA TABLE DES MATIÈRES PRODUITE
----------------------------------------

%{flabels}
%{separation}
%{lignes}
%{separation}
%{fspeccols}
EOT

  # Construction des documents du projet
  def exec_building
    CLI.debug_entry
    documents_params_are_valid_or_raise
    analyse_data_source
    proceed_build_apercu
    simulation? || begin
      if confirm_all? && ask_for_fermeture
        proceed_build_documents
        finish_execution
      end
    end
    CLI.debug_exit
  end

  # ---------------------------------------------------------------------

  def confirm_all?
    self.building_options = {
      ids:      false,
      targets:  false
    }
    if colonne_identifiant?
      building_options[:ids] = yesOrNo('Dois-je créer la métadonnée ID avec l’identifiant du document ?')
    end
    if target_column
      building_options[:targets] = yesOrNo('Dois-je tenir compte des objectifs définis ?')
    end
    yesOrNo('Puis-je procéder à la création ?')
  end
  # ---------------------------------------------------------------------

  # Vérifie qu'on ait bien toutes les données pour procéder à l'opération
  def documents_params_are_valid_or_raise
    self.src_document = CLI.options[:from]
    self.src_document || raise_no_source_document
    src_init = self.src_document.dup
    File.exist?(src_document)     || self.src_document = File.join(folder, src_document)
    File.exist?(src_document)     || raise_source_unfoundable(src_init)
    self.cell_delimitor = CLI.options[:delimitor] || ';'
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
  end

  # Procédure qui construit pour de bon le document
  def procedure_real
    lambda do |line, idx_line|
      dline = traite_ligne(line, idx_line, false)
      NewElement.new(self, self.last_folder, dline).treate
    end
  end
  # /procedure_real

  # Procédure de fin de la création
  def finish_execution
    self.xfile.save
  end
  # /finish_execution

  def proceed_each_line procedure
    idx_line = -1
    File.new(src_document).each_line.with_index do |line, index_real_line|
      line.strip.empty?     && next
      line.start_with?('#') && next
      idx_line += 1
      !CLI.options[:no_heading] && idx_line < 1 && next # passer l'entête
      procedure.call(line, index_real_line)
    end
  end


  # On procède vraiment à l'opération
  def proceed_build_apercu
    # = Affichage de la table =
    apercu = OVERVIEW_BUILD_DOCUMENT
    separation = '   -'.ljust(formated_labels.length + 2, '-')

    # Pour mettre des colonnes spéciales en pied de page
    formated_spec_cols = Array.new

    # Si une colonne pour l'objectif a été trouvée, on l'indique
    search_target_column
    unless target_column.nil?
      formated_spec_cols << ('  Colonne des objectifs : %i%s' % [target_column + 1, target_column > 0 ? 'e' : 'ère'])
    end
    if colonne_identifiant?
      formated_spec_cols << ('  Colonne des ID : %i%s' % [id_column + 1, id_column > 0 ? 'e' : 'ère'])
    end

    unless formated_spec_cols.empty?
      formated_spec_cols << separation
      formated_spec_cols << String::RC * 2
      formated_spec_cols = formated_spec_cols.join(String::RC)
    end

    rf_temp.rewind
    puts apercu % {
      flabels:      formated_labels,
      separation:   separation,
      lignes:       rf_temp.read,
      fspeccols:    formated_spec_cols
    }
  end

  def simulation?
    self.class.simulation == true
  end


  def formated_labels
    @formated_labels ||= begin
      labels_list = labels.empty? ? Array.new(self.cell_count, '') : labels
      # puts "\n-- labels list: #{labels_list.inspect}"
      dlabels = labels_list.collect.with_index do |lab, col_idx|
        lab.ljust(table_data[col_idx][:max_len])
      end
      # puts "\n-- dlabels: #{dlabels.inspect}"
      temp_line % dlabels
    end
  end
  def procedure_simulation
    lambda do |line, idx_line|
      dline = traite_ligne(line, idx_line, true)
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
    @temp_line ||= '    ' + Array.new(self.cell_count, '%s').join('  |  ') + String::RC
  end

  # Vérifie que le document fourni soit valide, sinon produit une erreur
  def document_source_is_valide_or_raise
    File.stat(src_document).size > 0 || raise_empty_document_source(src_document)
    # On passe chaque ligne du document en revue
    header_treated = false
    File.new(src_document).each_line.with_index do |line, idx_in_file|
      line.strip.empty?     && next
      line.start_with?('#') && next
      if CLI.options[:no_heading] || header_treated
        traite_ligne(line[0...-1], idx_in_file, true)
      elsif !CLI.options[:no_heading]
        traite_ligne_entete(line.strip)
        header_treated = true
      end
    end
  end
  private :document_source_is_valide_or_raise

  # Retourne la liste des cellules traitées
  # Noter qu'on passe deux fois par cette méthode, ce qui explique l'utilisation
  # de +control+ : une fois pour contrôler la validité du fichier et relever
  # les informations de longueurs (pour l'affichage) et la seconde fois pour
  # injecter les données.
  def traite_ligne lig, idx_in_file = nil, control = false
    # ATTENTION : de pas tripper la ligne, elle se termine peut-être par
    # des tabulations en délimiteur
    dline = lig.split(cell_delimitor, 1000) # 1000 pour ne pas supprimer les vides
    if control
      if self.cell_count.nil?
        dline.count > 1 || raise_delimitor_required
        self.cell_count = dline.count
      else
        # Quand le nombre de cellules est défini
        bon_nombre_de_cellules_or_raise("Lig.#{idx_in_file + 1} : #{lig}", dline, self.cell_count)
      end
      self.labels ||= Array.new(self.cell_count, '')
      self.table_data ||= begin
        # S'il n'y avait pas de première ligne de label, il faut
        # construire table_data
        h = Hash.new
        self.cell_count.times do |itime|
          h.merge!(itime => {
            max_len: (labels[itime] || '').length,
            maybe_target: true # pour indiquer que ça peut être la colonne target
          })
        end
        h
      end

      # Profondeur
      # Si une profondeur est définie, on ne doit trouver qu'une et une
      # seule valeur doit les <profondeur> premières colonnes.
      # trouvée dans les x première cellules, soit aucune profondeur
      # n'est définie et la première colonne doit comprendre une valeur
      if profondeur.nil?
        dline[0].strip != '' || raise_depth_required
      else
        une_valeur_deja_definie = false
        (0...profondeur).each do |ival|
          val = dline[ival].strip
          val != '' || next
          if une_valeur_deja_definie
            raise_double_value_profondeur(lig, idx_in_file)
          else
            une_valeur_deja_definie = true
          end
        end
      end
    end


    # puts "\n-- table_data: #{table_data.inspect}"

    # On en profite pour voir les longueurs max des cellules
    # Et on retourne la liste de cellule car la méthode sert aussi bien
    # pour le premier tour (relève et contrôle) que pour le second (traitement)
    dline.collect.with_index do |cell, idx|
      cell = cell.strip
      if ['m','w','p','s'].include?(cell[-1])
        ret = SWP.signs_from_human_value(cell)
        if ret.nil?
          control && self.table_data[idx][:maybe_target] = false
        else
          cell = ret.to_s
        end
      elsif cell.to_s == '' || cell.match(/^[0-9]+$/)
        # On laisse cell telle quelle
      else
        CLI.dbg("#{cell.inspect} ne peut pas être un objectif")
        control && self.table_data[idx][:maybe_target] = false
      end
      if control && self.table_data[idx][:max_len] < cell.length
        len = cell.length
        len < 40 || len = 40
        self.table_data[idx][:max_len] = len
      end
      cell
    end
  end
  # /traite_ligne

  # La profondeur définie dans les options
  def profondeur
    @profondeur ||= begin
      p = CLI.options[:depth].to_i
      p > 0 ? p : nil
    end
  end
  # /profondeur

  def traite_ligne_entete line
    self.labels = line.split(cell_delimitor).collect{|l|l.strip}
    self.labels.count > 1 || raise_delimitor_required
    # On peut définir ici le nombre de cellules attenues
    self.cell_count = self.labels.count
  end


  def bon_nombre_de_cellules_or_raise lig, dline, nb_expected
    dline.count == nb_expected || raise_bad_nombre_cellules(lig, dline.count, nb_expected)
  end


  # Retourne true si une colonne portant le nom 'id' a été trouvé
  # En fait, retourne l'index de la colonne.
  def colonne_identifiant?
    labels.each_with_index do |label, idx_label|
      if label.downcase == 'id'
        self.id_column = idx_label
        return true
      end
    end
    return nil
  end
  # Méthode qui cherche une colonne pouvant définir les objectifs de
  # mots/pages/signes à atteindre.
  # Si deux colonnes candidates ont été trouvées, il faut que les
  # libellés les départagent.
  def search_target_column
    table_data.each do |idx_col, dcol|
      if dcol[:maybe_target]
        if self.target_column
          # Si une colonne des cibles a déjà été trouvée, il faut
          # rechercher dans les labels ou produire une erreur
          labels.empty? && raise_double_colonnes_target
          labels.each_with_index do |label, sidx_col|
            if label.match(/^(cible|target|objectif)s?$/i)
              self.target_column = sidx_col
              return
            end
          end
          # Si on passe par ici, c'est qu'aucun label n'a pu
          # définir la colonne des objectifs
          raise_double_colonnes_target
        end
        self.target_column = idx_col
      end
    end
  end
  # /search_target_column
  private :search_target_column

end#/module
