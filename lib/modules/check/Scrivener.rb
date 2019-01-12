# encoding: UTF-8
class Scrivener
class << self

  # {String} Ce qui doit être vérifier. Par exemple 'installation'

  attr_accessor :what

  def exec_check
    what || return
    send("exec_check_#{what}".to_sym)
    puts String::RC * 3
  end

  # ---------------------------------------------------------------------
  #   Méthodes de vérification


  # ---------------------------------------------------------------------
  #   Méthodes utilitaires

  def puts_check d
    begin
      value     = eval(d[:value])
      expected  = eval(d[:expected])
      is_ok     = eval(d[:evaluate])
    rescue Exception => e
      puts e.message.rouge
    end
    d.merge!(sujet: is_ok ? d[:success_msg] : d[:failure_msg])
    str = d[:sujet] % {value: value, expected: expected}
    puts ('  - ' + str.ljust(70) + (is_ok ? 'OK' : 'NOT OK')).send(is_ok ? :vert : :rouge)
    unless is_ok || d[:solve].nil?
      d[:solve] = [d[:solve]] if d[:solve].is_a?(String)
      puts '         %s%s:' % [t('solution.tit.sing'),FRENCH_SPACE]
      d[:solve].each do |msg|
        puts ('          - %s' % msg).bleu
      end
    end
  end

  # ---------------------------------------------------------------------
  #   Données

  # Ce qu'il faut vérifier
  def what
    @what ||= begin
      case CLI.params[1]
      when 'install', 'installation'
        :install
      else
        non_fatal_error(t('commands.check.errors.no_what'))
      end
    end
  end

  # TODO Présence de l'application Scrivener
  # TODO Version de l'application Scrivener

  # ---------------------------------------------------------------------
  #   Méthodes fonctionnelles

  def non_fatal_error(err)
    puts err.gsub(/\\n/,String::RC).rouge
    return false
  end
  alias :error_non_fatale :non_fatal_error

end #/<< self
end #/Scrivener
