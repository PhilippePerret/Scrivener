# encoding: UTF-8
=begin
  Module pour la commande 'build'
=end
module BuildDocumentsModule


  # La classe pour conserver les définitions qui permettent de construire
  # les documents
  class BuildingSettings

OVERVIEW_SETTINGS = <<-TXT

  Réglages de construction
  ------------------------

    %{tit_fichier_csv} : %{ffilecsv}
    %{tit_delimitor} : %{fdelimitor}
    %{tit_target_unit} : %{ftarget}
    %{tit_depth} : %{fdepth}
TXT

    attr_accessor :projet
    def initialize iprojet
      self.projet = iprojet
    end
    # Le document CSV source contenant les données
    attr_writer :source_csv
    def source_csv
      @source_csv ||= begin
        CLI.options[:from].or_nil || begin
          @source_csv_is_default = true
          'tdm.csv'
        end
      end
    end
    def source_csv_default?
      !!@source_csv_is_default
    end
    attr_accessor :source_csv_init # initialement défini
    attr_accessor :real_source_csv # le bon
    # Le délimiteur de cellules
    def cell_delimitor
      @cell_delimitor ||= begin
        CLI.options[:delimitor].or_nil || begin
          @cell_delimitor_is_default = true
          ';'
        end
      end
    end
    def cell_delimitor_default?
      !!@cell_delimitor_is_default
    end
    # La profondeur de dossiers/documents
    def depth
      @depth ||= begin
        CLI.options[:depth].to_i.or_nil || begin
          @depth_is_default = true
          1
        end
      end
    end
    def depth_default?
      !!@depth_is_default
    end
    # L'unité pour les cibles
    def target_unit
      @target_unit ||= begin
        case CLI.options[:target_unit].or_nil
        when nil
          @target_unit_is_default = true
          :page
        when 'page', 'pages', 'p' then :page
        when 'mot', 'word', 'mots', 'words', 'w' then :word
        else :sign
        end
      end
    end
    def small_target_unit
      @small_target_unit ||= begin
        {
          page: 'p', word: 'w', sign: 's'
        }[target_unit]
      end
    end
    def target_unit_default?
      !!@target_unit_is_default
    end

    # Le nombre de cellules trouvées
    attr_accessor :cell_count
    # les labels
    attr_accessor :labels
    # La colonne des cibles/objectifs
    attr_accessor :target_column
    # La colonne des ID
    attr_accessor :id_column
    # Retourne true s'il existe une ligne de labels
    def heading?
      options[:heading] == true
    end
    # Les options (pour le moment, ne sert pas)
    def options
      @options ||= {
        create_id_metadata:     false,
        create_target_metadata: false,
        heading:                !CLI.options[:no_heading]
      }
    end

    # ---------------------------------------------------------------------
    #   Méthodes d'helper
    def formated_labels
      return '' if labels.nil?
      @formated_labels ||= begin
        labels_list = labels.empty? ? Array.new(cell_count, '') : labels
        # puts "\n-- labels list: #{labels_list.inspect}"
        dlabels = labels_list.collect.with_index do |lab, col_idx|
          lab.ljust(projet.table_data[col_idx][:max_len])
        end
        # puts "\n-- dlabels: #{dlabels.inspect}"
        projet.temp_line % dlabels
      end
    end

    def overview
      # Afficher un résumé de l'opération :
      puts OVERVIEW_SETTINGS % {
        tit_fichier_csv:  formate_titre('Fichier CSV', source_csv_default?),
        ffilecsv:         real_source_csv.relative_path(projet.folder),
        tit_delimitor:    formate_titre('Délimiteur', cell_delimitor_default?),
        fdelimitor:       cell_delimitor.inspect,
        tit_target_unit:  formate_titre('Unité cibles', target_unit_default?),
        ftarget:          target_unit.inspect,
        tit_depth:        formate_titre('Profondeur', depth_default?),
        fdepth:           depth || '---'
      }

    end

    def formate_titre titre, par_default
      ('%s %s' % [titre, par_default ? '(par défaut)' : '']).ljust(30)
    end


    # ---------------------------------------------------------------------
    #   Méthodes fonctionnelles
    def source_csv_exist?
      self.source_csv_init = source_csv == :default ? 'tdm.csv' : source_csv
      self.real_source_csv = source_csv_init.dup
      File.exist?(real_source_csv) && (return true)
      self.real_source_csv = File.join(projet.folder, real_source_csv)
      return File.exist?(real_source_csv)
    end

    # ---------------------------------------------------------------------
  end
  # /BuildingSettings

end#/module
