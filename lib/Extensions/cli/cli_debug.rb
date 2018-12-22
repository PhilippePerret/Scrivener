# encoding: UTF-8
=begin
  Méthodes de débuggage de CLI
=end

class CLI
class << self

  # Sortie de CLI.dbg (pour définir s'il faut sortir dans un fichier,
  # dans le programme, etc.)
  # Par défaut, la sortie standard (puts) est employée
  attr_accessor :debug_output

  # Messagerie
  def log mess
    puts "\033[1;94m#{mess}\033[0m"
  end
  def error err_mess
    puts "\033[1;31m#{err_mess}\033[0m"
    return false
  end

  # Note l'entrée dans la méthode où est appelé cette méthode dans le
  # fichier de débug (ou la sortie débug chosie)
  #
  # @usage:
  #
  #   def ma_fonction
  #      CLI.debug_entry[('mon commentaire')]
  #
  def debug_entry comments = nil
    debug_inout(:in, comments)
  end

  def debug_exit comments = nil
    debug_inout(:out, comments)
  end
  def debug_inout sens = :in, comments = nil
    begin
      raise
    rescue => e
      line_function = e.backtrace[2]
      file, line, method = line_function.match(/^(.+?)\:([0-9]+)\:in `(.*?)'$/).to_a[1..-1]
      dbg('%s %s %s' % [sens == :in ? '-->' : '<--', method, comments || ''], file, line)
    end
  end

  def dbg msg, file = nil, line = nil
    verbose? || self.debug_output != nil || begin
      return
    end
    if file || line
      relative_file = file.sub(/#{APPFOLDER}\//, '')
      msg << ' (%s%s)' % [relative_file, line ? ":#{line}" : '']
    end
    case self.debug_output
    when nil  then puts msg
    when :log then Debug.write(msg)
    when String then File.open(debug_output,'a'){|f|f.write msg}
    else
      raise 'Impossible de trouver la sortie de CLI.dbg'
    end
  end
  alias :debug :dbg


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
    @keys_mode_test ||= options[:keys_mode_test].to_s.split(';;;')
    return @keys_mode_test.shift
  end

  def mode_interactif?
    @is_mode_interactif === nil && begin
      @is_mode_interactif = options[:keys_mode_test].nil?
    end
    @is_mode_interactif
  end

end #/<< self
end #/ CLI
