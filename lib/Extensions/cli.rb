#!/usr/bin/env ruby
# encoding: UTF-8
#
# CLI 1.2.2
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
#     CLI.dbg
#   On peut diriger la sortie des débugs vers une autre sortie à l'aide de
#     CLI.debug_output
#   … qui peut avoir la valeur :
#     nil         Les messages sont écrits en console
#     :log        Les messages sont écrits dans le fichier debug.log
#     'path/file' Les messages sont écrits dans le fichier spécifié
#
#   Pour benchmarker l'application :
#   --------------------------------
#     CLI.benchmark(:start, '<nom >')
#     ...
#     CLI.benchmark(:stop[, <autre titre>])
#
# Note 1.2.1
#   Les '-' dans le nom des options sont remplacés par des traits plats.
#   'in-file' => 'in_file'
#
class CLI

  BENCHMARK = Hash.new

  class << self

    attr_accessor :command, :params, :options

    attr_accessor :last_command # sans l'application

    # Sortie de CLI.dbg
    attr_accessor :debug_output

    # Historique des commandes
    attr_reader :historique, :i_histo

    # Pour benchmarker l'application
    def benchmark ope, titre = nil
      VERBOSE || BENCHMARK[:oui] || return
      case ope
      when :start
        BENCHMARK.merge!(start_time: Time.now.to_f, title: titre || 'Départ benchmark')
      when :stop
        BENCHMARK.merge!(stop_time: Time.now.to_f)
        titre.nil? || BENCHMARK.merge!(title: titre)
        dbg "    #{BENCHMARK[:title]} *** #{(BENCHMARK[:stop_time] - BENCHMARK[:start_time]).round(4)} secs".gris
      end
    end

    # Si des touches ont été fournies par l'option `-k=` ou `keys_mode_test`,
    # on envoie les touches envoyées au lieu de passer par un mode interactif
    #
    # Dans le programme on utilise
    #   if CLI.mode_interactif?
    #      # le traitement normal
    #       return touche
    #   else
    #     return CLI.next_key_mode_test
    #   end
    #
    def next_key_mode_test
      @keys_mode_test ||= options[:keys_mode_test].split(';;;')
      return @keys_mode_test.shift
    end

    def mode_interactif?
      @is_mode_interactif === nil && begin
        @is_mode_interactif = options[:keys_mode_test].nil?
      end
      @is_mode_interactif
    end

    # Pour savoir si c'est la ligne de commande qui est utilisée
    def command_line?
      true
    end

    def dbg msg
      VERBOSE || return
      case self.debug_output
      when nil  then puts msg
      when :log then Debug.write(msg)
      when String then File.open(debug_output,'a'){|f|f.write msg}
      else
        raise 'Impossible de trouver la sortie de CLI.dbg'
      end
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
      msg << "\n"
      msg << "Choisir la commande :"
      @historique.each_with_index{|c,i| msg << "\t#{(i+1).to_s.ljust(4)} #{c}"}
      msg << "\n"
      puts msg.join("\n")
      choix = getc("Commande à rejouer")
      case choix
      when /^([0-9]+)$/
        return @historique[choix.to_i - 1]
      end
    end

    # Utiliser CLI.verbose? pour savoir si c'est le mode verbeux ?
    # Utiliser l'option --verbose ou -vb mais définir alors dans le
    # DIM_OPT_TO_REAL_OPT de l'application : 'vb' => 'verbose'
    def verbose?
      self.options && self.options[:verbose]
    end
    def quiet?
      self.options && self.options[:quiet]
    end

    # Initialisation de CLI
    def init
      # La commande = le premier mot (pas forcément)
      self.command= nil
      # log "Commande : #{CLI.command.inspect}"
      self.options  = Hash.new
      self.params   = (a = Array.new ; a << nil ; a)
    end

    # Analyse de la ligne de commande
    def analyse_command_line arguments_v = nil
      arguments_v ||= ARGV
      init
      # On mémorise la dernière commande, c'est-à-dire la ligne complète fournie
      # à cette méthode.
      self.last_command = (arguments_v||[]).join(' ')
      # On ajoute cette commande à l'historique courant
      add_historique(self.last_command)

      # Ensuite, on peut trouver des paramètres ou des options. Les options
      # se reconnaissent au fait qu'elles commencent toujours par "-" ou "--"
      # puts "ARGV : #{ARGV.inspect}"
      arguments_v.empty? || begin
        arguments_v.each do |argv|
          if argv.start_with?('-')
            traite_arg_as_option argv
          elsif self.command.nil?
            self.command = (DIM_OPT_TO_REAL_OPT[argv] || argv).gsub(/\-/,'_')
          else
            traite_arg_as_param argv
          end
        end
      end

      BENCHMARK.merge!(oui: options[:benchmark])
      return true
    end

    def traite_arg_as_option arg
      if arg.start_with?('--')
        opt, val = arg[2..-1].strip.split('=')
        opt.gsub!(/-/,'_')
      else # is start_with? '-'
        # <= diminutif
        opt_dim, val = arg[1..-1].strip.split('=')
        opt = DIM_OPT_TO_REAL_OPT[opt_dim]
        opt != nil || begin
          error "L'option #{opt_dim.inspect} est inconnue…"
          return
        end
      end
      self.options.merge!(opt.to_sym => real_val_of(val))
    end

    # La vraie valeur de l'option, qui est exprimée forcément en
    # string.
    # Noter que nil retourne true
    def real_val_of val
      case val
      when 'false'        then false
      when 'true'         then true
      when 'null', 'nil'  then nil
      when /^[0-9]+$/       then val.to_i
      when /^[0-9\.]+$/     then val.to_f
      when nil            then true
      else
        val
      end
    end

    def traite_arg_as_param arg
      self.params << arg
    end

    # Messagerie
    def log mess
      puts "\033[1;94m#{mess}\033[0m"
    end
    def error err_mess
      puts "\033[1;31m#{err_mess}\033[0m"
      return false
    end

  end #/<< self
end #/CLI
