# encoding: UTF-8
=begin

Module pour méthodes de test en ligne de commmande

=end
require 'rake'
require 'rake/testtask'

class CLI
class Test
class << self


  # Permet de jouer les tests voulus de l'application courante
  # cf. Manuel > Tests.rb
  # @usage    CLI::Test.run
  def run(path, options = nil)

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


    app = Rake.application
    app.init('raketest', nil)
    # Le deuxième argument est ARGV par défaut, mais on ne doit rien
    # envoyer ici parce que c'est CLI qui doit gérer ces options

    # Définir la tâche qui va jouer les tests
    Rake::TestTask.new do |t|
      # t.libs = ["lib"]|
      t.name = 'tests'
      t.warning     = !!options[:warning]
      t.verbose     = !!options[:verbose]
      if t.verbose
        t.options = '-%s' % [t.verbose ? 'v' : '']
      end
      t.test_files  =
        if test_files
          test_files
        elsif File.directory?(path)
          path.end_with?('/') || path.concat('/')
          FileList["#{path}**/ts_*.rb"]
        else
          [path]
        end
    end

    # On joue les tests
    app['tests'].invoke()
  end



  # Simule la commande +command+ et joue les touches [<+touche+>] au fur
  # et à mesure des besoins interactivement.
  #
  # RETURN Le résultat final produit par la commande.
  def run_command command, touches = nil
    if touches
      touches.is_a?(Array) || touches = [touches]
      touches = touches.join(';;;')
      # command << ' --benchmark'
      command << ' -k="%s"' % touches
    end
    # puts "Commande jouée : #{cmd.inspect}"
    res = `#{command} > #{output_path}`
    return res
  end

  # Résultat de la dernière commande `run_command` jouée.
  # @usage:  res = CLI::Test.output
  def output
    File.exist?(output_path) && File.read(output_path).force_encoding('utf-8')
  end

  def output_path
    @output_path ||= File.join('.','test','run_command_output.log')
  end

end #/<< self
end #/Test
end #/CLI
