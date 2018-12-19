# encoding: UTF-8
=begin

Module pour méthodes de test en ligne de commmande

=end

class CLI
class Test
  class << self
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
