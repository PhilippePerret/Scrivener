# encoding: UTF-8
=begin

Module pour méthodes de test en ligne de commmande

=end
require 'tempfile'
require 'rake'
require 'rake/testtask'

class CLI
class Test
class << self


  # Permet de jouer les tests voulus de l'application courante
  # cf. Manuel > Tests.rb
  # @usage    CLI::Test.run
  def run(path, options = nil)
    CLI.debug_entry
    if CLI.options[:help]
      # Si l'aide est demandée, on l'affiche et on s'en retourne.
      require_relative 'test_aide'
      CLI::Screen.less(CLITestHelp::aide_test_cmd)
      return
    end
    options ||= CLI.options
    path = path.to_s # peut être nil

    # On cherche les fichiers à tester
    test_files = nil
    if path.start_with?('^') && path.end_with?('$')
      # <= C'est une expression régulière
      # => On cherche tous les fichiers qui correspondent
      filtre = path[1...-1]
      filtre = filtre.gsub(/\\/, '\\')
      regexp = Regexp.new(filtre)
      test_files = Dir['./test/**/ts_*.rb'].collect do |p|
        p.match(regexp) || next
        p
      end.compact
      test_files.count > 0 || begin
        fail 'Aucun fichier ne répond au filtre /%s/' % filtre
      end
      puts "Filtre : /#{filtre.inspect}/"
      puts "Fichiers filtrés : #{test_files.inspect}"
    else
      path = './test/%s' % [path]
    end

    CLI.dbg "SUIVI --> Create Rake application"
    app = Rake.application
    # app.init('raketest', nil)
    app.init('raketest', ['-f'])
    #                       ^---------- juste pour obliger à avoir seulement
    #                                   cette option. Sinon, prend tout ARGV
    #                                   et ça pose des problèmes avec les
    #                                   options comme --location par exemple.
    CLI.dbg "SUIVI --> Rake application inited"
    # Le deuxième argument est ARGV par défaut, mais on ne doit rien
    # envoyer ici parce que c'est CLI qui doit gérer ces options

    # Définir la tâche qui va jouer les tests
    Rake::TestTask.new do |t|
      # t.libs = ["lib"]|
      t.name = 'tests'
      t.warning     = !!options[:warning]
      t.verbose     = !!options[:verbose]
      if t.verbose
        t.options   = '-%s' % [t.verbose ? 'v' : '']
        # t.ruby_opts = ['-v']
      end
      # t.options = '-h'
      # t.options = '--testcase="avec des documents précédemment construits" '
      if test_line = CLI.options.delete(:line) || CLI.options.delete(:location)
        t.options ||= ''
        t.options << +" --location=#{test_line}"
      end

      t.test_files=
        if test_files
          test_files
        elsif File.directory?(path)
          path.end_with?('/') || path.concat('/')
          FileList["#{path}**/ts_*.rb"]
        else
          [path]
        end
    end

    # Si une méthode before_all existe, on la joue
    phelpertest = File.join(APPFOLDER,'test','test_helper.rb')
    require phelpertest if File.exist?(phelpertest)

    self.respond_to?(:before_all) && begin
      CLI.dbg "SUIVI --> Scrivener.before_all"
      self.before_all
      CLI.dbg "SUIVI <-- Scrivener.before_all"
    end

    begin
      # On joue les tests
      CLI.dbg "SUIVI --> invocation des tests"
      app['tests'].invoke()
    rescue Exception => e
      raise e
    ensure
      self.respond_to?(:after_all) && begin
        CLI.dbg "SUIVI --> Scrivener.after_all"
        self.after_all
        CLI.dbg "SUIVI <-- Scrivener.after_all"
      end
    end
  end



  # Simule la commande +command+ et joue les touches [<+touche+>] au fur
  # et à mesure des besoins interactivement.
  #
  # RETURN Le résultat final produit par la commande.
  def run_command command, touches = nil, options = nil
    reset_run_command
    if touches
      touches.is_a?(Array) || touches = [touches]
      touches = touches.join(';;;')
      # command << ' --benchmark'
      command << ' -k="%s"' % touches
    end
    # puts "Commande jouée : #{cmd.inspect}"
    full_command = "cd \"#{APPFOLDER}\";#{command} > #{output_path}"
    # puts "\nCMD: #{full_command}"
    res = `#{full_command}`
    if options && options[:debug]
      puts self.output
      debug self.output
    end
    return res
  end

  def reset_run_command
    @output = @output_path = @output_file = nil
  end

  # Résultat de la dernière commande `run_command` jouée.
  # @usage:  res = CLI::Test.output
  # @note: remis à nil chaque fois que la commande run est
  # invoquée
  def output
    @output ||= output_file.read
  end
  def output_path
    @output_path ||= output_file.path
  end
  def output_file
    @output_file ||= Tempfile.new('output_test')
  end

end #/<< self
end #/Test
end #/CLI
