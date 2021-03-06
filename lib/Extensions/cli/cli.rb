#!/usr/bin/env ruby
# encoding: UTF-8
#
# CLI
#
# VERSION: cf. fichier cli_notes_versions.md
# (Penser à prendre tout le dossier, pas seulement ce module)
#
# MODE D'EMPLOI
# -------------
#   Voir le manuel dans le dossier.
#
# Note : l'application doit définir :
#   class CLI
#     DIM_OPT_TO_REAL_OPT = {
#       '<diminutif>' => '<version longue>',
#       '<diminutif>' => '<version longue>',
#       etc.
#     }
#
#   On obtient la valeur d'une option par :
#     CLI.options[<key option>]
#
#   Pour afficher un message de debug si l'option -vb/--verbose est
#   utilisée :
#     CLI.dbg <error|message>[, __FILE__][, __LINE__]
#   On peut diriger la sortie des débugs vers une autre sortie à l'aide de
#     CLI.debug_output
#   … qui peut avoir la valeur :
#     nil         Les messages sont écrits en console
#     :log        Les messages sont écrits dans le fichier debug.log
#     'path/file' Les messages sont écrits dans le fichier spécifié
#
#   Pour mettre la verbosité en route seulement sur un passage, mettre
#   CLI.verbose # à l'endroit où doit commencer la verbosité
#   CLI.verbose(false) # à l'endroit où doit s'arrêter la verbosité
#
#   Pour benchmarker l'application :
#   --------------------------------
#     CLI.benchmark(:start, '<nom >')
#     ...
#     CLI.benchmark(:stop[, <autre titre>])
#
class CLI

  BENCHMARK = Hash.new

  class << self

    attr_accessor :app_name, :command, :params, :options
    # {String} La commande initiale, telle qu'elle a été envoyée
    attr_accessor :command_init

    attr_accessor :last_command # sans l'application

    # Historique des commandes
    attr_reader :historique, :i_histo


    def mode_test?
      ENV['CLI_MODE_TEST'] == 'true'
    end

    # Initialisation de CLI
    #
    # +options+
    #   :output     Sortie à utiliser (un fichier par défaut)
    def init options = nil
      options ||= Hash.new

      # Certains constantes sont indispensables
      defined?(DIM_CMD_TO_REAL_CMD) || raise('La constante CLI::DIM_CMD_TO_REAL_CMD doit être définie pour l’application courante.')
      defined?(APP_CORRESPONDANCES) || raise('La constante CLI::APP_CORRESPONDANCES doit être définie pour l’application courante.')

      # L'application
      # puts "constantes : #{File.constants}"
      self.app_name = ENV['_'].split(File::SEPARATOR).last
      # La commande = le premier mot (pas forcément)
      self.command= nil
      # log "Commande : #{CLI.command.inspect}"
      self.options  = Hash.new
      # self.params   = (a = Array.new ; a << nil ; a)
      # self.params   = Array.new(1, nil)
      self.params   = Hash.new()
      self.params.merge!(0 => nil)
      self.debug_output = options[:output] || :log # File.expand_path('./test_debug.log')
    end
    # /init

    # = main =
    #
    # Analyse de la ligne de commande
    #
    # C'est la première méthode que doit appelée l'application.
    #
    def analyse_command_line arguments_v = nil
      arguments_v ||= ARGV

      init

      # On mémorise la dernière commande, c'est-à-dire la ligne complète fournie
      # à cette méthode.
      self.last_command = (arguments_v||[]).join(' ')
      # On ajoute cette commande à l'historique courant
      add_historique(self.last_command)

      # Si on rencontre la marque '--' seule, on continue d'étudier
      # les options, mais on ne génère plus d'alerte si on en trouve
      # qui ne sont pas connues.
      @mark_uncaugth_options_found = false

      # Ensuite, on peut trouver des paramètres ou des options. Les options
      # se reconnaissent au fait qu'elles commencent toujours par "-" ou "--"
      # puts "ARGV : #{ARGV.inspect}"
      arguments_v.empty? || begin
        arguments_v.each do |argv|
          if argv.start_with?('-')
            traite_arg_as_option argv
          elsif self.command.nil?
            self.command_init = argv
            self.command = command_vdef(argv)
          else
            traite_arg_as_param argv
          end
        end
      end

      BENCHMARK.merge!(oui: options[:benchmark])

      if self.command == 'todo'
        # Traitement spécial de la commande universelle `todo`
        CLI::Todo.run
        return false
      elsif self.command == 'test'
        # Traitement spécial de la commande universelle 'test'
        Dir.chdir(APPFOLDER) do
          CLI::Test.run(CLI.params[1])
        end
        return false
      end

      return true
    end
    # /analyse_command_line

    # La version définitive de la commande
    def command_vdef(argv)
      if APP_CORRESPONDANCES.key?(argv)
        APP_CORRESPONDANCES[argv]
      elsif DIM_OPT_TO_REAL_OPT.key?(argv)
        DIM_OPT_TO_REAL_OPT[argv]
      elsif DIM_CMD_TO_REAL_CMD.key?(argv)
        cmd = DIM_CMD_TO_REAL_CMD[argv]
        cmd.is_a?(Array) || (return cmd)
        # Quand cmd est un array, il définit en premier élément le vrai
        # nom de commande à utiliser et en argument un Hash définissant les
        # nouvelles options. Par exemple quand on fait `monapp update truc`,
        # si DIM_CMD_TO_REAL_CMD[:update] = ['build', {update: true}], alors
        # la commande `update` est remplacée par `build` et l'option :update
        # est ajoutée, avec la valeur true
        CLI.options.merge!(cmd.last)
        cmd.first
      else
        argv
      end.gsub(/\-/,'_')
    end

    # Pour benchmarker l'application
    def benchmark ope, titre = nil
      verbose? || BENCHMARK[:oui] || return
      case ope
      when :start
        BENCHMARK.merge!(start_time: Time.now.to_f, title: titre || 'Départ benchmark')
      when :stop
        BENCHMARK.merge!(stop_time: Time.now.to_f)
        titre.nil? || BENCHMARK.merge!(title: titre)
        dbg "    #{BENCHMARK[:title]} *** #{(BENCHMARK[:stop_time] - BENCHMARK[:start_time]).round(4)} secs".gris
      end
    end


    # Pour savoir si c'est la ligne de commande qui est utilisée
    def command_line?
      true
    end



    def add_historique cmd
      @historique ||= Array.new
      @historique << cmd
      @i_histo = @historique.count - 1
    end

    # Effacer le dernier élément de l'historique.
    # On peut le faire lorsque la dernière commande n'était pas valide, et qu'on
    # ne veut pas l'enregistrer.
    def delete_last_in_historique
      @historique || (return error('Aucune commande n’a encore été entrée. Pas d’historique des commandes.'))
      @historique.pop
    end

    # Affiche l'historique des commandes et permet d'en choisir une
    def choose_from_historique
      @historique || (return error('Aucune commande n’a encore été entrée. Pas d’historique des commandes.'))
      msg = Array.new
      msg << String::RC
      msg << 'Choisir la commande :'
      @historique.each_with_index{|c,i| msg << "\t#{(i+1).to_s.ljust(4)} #{c}"}
      msg << String::RC
      puts msg.join("\n")
      choix = getc('Commande à rejouer')
      case choix
      when /^([0-9]+)$/
        return @historique[choix.to_i - 1]
      end
    end

    # Utiliser CLI.verbose? pour savoir si c'est le mode verbeux ?
    # Utiliser l'option --verbose ou -vb mais définir alors dans le
    # DIM_OPT_TO_REAL_OPT de l'application : 'vb' => 'verbose'
    def verbose?
      self.options[:verbose] === true
    end
    def verbose set_on = true
      self.options.merge!(verbose: set_on)
    end
    def quiet?
      self.options[:quiet]
    end

    def traite_arg_as_option arg
      if arg == '--'
        # Certaines
        # Les options qui seront définies après cette marque ne doivent pas être
        # étudiées, on peut s'arrêter là
        @mark_uncaugth_options_found = true
        return
      elsif arg.start_with?('--')
        opt, val = arg[2..-1].strip.split('=')
        opt.gsub!(/-/,'_')
        opt = LANG_OPT_TO_REAL_OPT[opt] || APP_CORRESPONDANCES[opt] || opt
      else # is start_with? '-'
        # <= diminutif
        #    (ou cas spécial de '-' tout seul)
        if arg == '-'
          traite_arg_as_param(arg)
          return
        else
          opt_dim, val = arg[1..-1].strip.split('=')
          opt = DIM_OPT_TO_REAL_OPT[opt_dim]
          opt != nil || @mark_uncaugth_options_found || begin
            error "L'option #{opt_dim.inspect} est inconnue de CLI… Il faut la définir dans cli_app.rb."
            return
          end
          opt ||= opt_dim # quand @mark_uncaugth_options_found est vrai
        end
      end
      self.options.merge!(opt.to_sym => real_val_of(val))
    end

    def traite_arg_as_param arg
      if arg.index(/[^ ]=[^ ]/)
        key, val = arg.split('=')
        key = key.to_sym
      else
        key = self.params.count
        val = arg
      end
      val = APP_CORRESPONDANCES[val] || val
      self.params.merge!(key => val)
    end

    # Dossier général de la commande CLI pour l'utilisateur courant
    # Initié pour conserver les todolists des applications dans un lieu
    # unique.
    def cli_home_folder
      @cli_home_folder ||= begin
        d = File.expand_path(File.join(Dir.home,'.cli'))
        `mkdir -p "#{d}"`
        d
      end
    end


  end #/<< self
end #/CLI
