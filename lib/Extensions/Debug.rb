=begin

  Quand on utilise Curses, il est difficile d'afficher les messages de
  débug et autres retours. On peut utiliser dans ce cas la méthode générale
  `debug` qui écrit le log des messages dans un fichier propre.

  Pour fonctionner, la classe doit connaitre APPFOLDER, le dossier de l
  l'application.

  ATTENTION : il faut avoir quitter l'application pour voir le fichier. Sinon,
  il est encore ouvert en écriture et ne peut pas être consulté.

=end
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
    File.unlink(log_file) if File.exists?(log_file)
  end

  def rf
    @rf ||= begin
      File.open(log_file, 'a')
    end
  end

  def log_file
    @log_file ||= File.join(APPFOLDER, 'debug.log')
  end

end #/<< self
end #/Debug
