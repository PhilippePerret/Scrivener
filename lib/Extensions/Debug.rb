=begin

  Quand on utilise Curses, il est difficile d'afficher les messages de
  débug et autres retours. On peut utiliser dans ce cas la méthode générale
  `debug` qui écrit le log des messages dans un fichier propre.

  Pour fonctionner, la classe doit connaitre APPFOLDER, le dossier de l
  l'application.

  ATTENTION : il faut avoir quitter l'application pour voir le fichier. Sinon,
  il est encore ouvert en écriture et ne peut pas être consulté.

=end
require 'tempfile'
def debug err
  Debug.write(err)
end
class Debug
class << self
  def write err
    err =
      case err
      when String then err
      else
        # Une erreur
        (["ERREUR : #{err.message}"] + err.backtrace[0..4]).join(String::RC)
      end
    rf.puts('--- [%s] %s' % [Time.now.strftime('%d %m %Y - %H:%M:%S'), err])
  rescue Exception => e
    raise e
  end

  def init
    rf.nil? || begin
      rf.close
      @rf = nil
    end
    File.unlink(log_path) if File.exists?(log_path)
  end

  def close
    rf.close
  end

  def rf
    @rf ||= begin
      # ref = File.open(log_path, 'a+')
      ref = Tempfile.new('scrivener_log')
      ref.write("\n\n\n=== #{Time.now.strftime('%d %m %Y - %H:%M:%S')} ===\n\n")
      ref
    end
  end

  def log_path
    @log_path ||= File.expand_path(File.join(APPFOLDER, 'debug.log'))
  end

end #/<< self
end #/Debug
