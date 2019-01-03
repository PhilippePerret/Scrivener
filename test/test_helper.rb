=begin
  Ce fichier doit être chargé par tous les tests en ajoutant en haut du
  fichier :

    require './test/tests_helper'

  Pour lancer le test :

    CMD-I s'il est est affiché dans Atom

    ruby ./test/**/*.rb <options> # dans la console pour lancer tous les tests.

    On peut régler le niveau de verbosité avec :
    -v, --verbose=[LEVEL]            Set the output level (default is verbose).
                                    (important-only, n[ormal], p[rogress], s[ilent], v[erbose])

    Avec --verbose=s on a rien
    Avec --verbose=n, on a le retour d'erreur un peu détaillé
    Avec --verbose=p, on a juste les F et les *

=end
# require 'pty'
require 'test/unit'

# # Pour obtenir un backtrace complet de l'erreur
# # Mais souvent, est-ce vraiment utile ?
# require 'test/unit/util/backtracefilter'
# module Test::Unit::Util::BacktraceFilter
#   def filter_backtrace(backtrace, prefix=nil)
#     backtrace
#   end
# end
# #/filter_backtrace

# Il faut requérir tous les requirements de l'application, notamment pour
# les données enregistrées dans les fichiers Marshal
require './lib/required'
CLI.init # notamment pour que CLI.options ne soit pas nil

# Pour CLI.mode_test?
ENV['CLI_MODE_TEST'] = 'true'

Dir['./test/support/**/*.rb'].each{|m| require m}

puts "\n\n\n\n"

# +touches+ est la liste des touches à jouer interactivement.
def run_commande cmd, touches = nil, options = nil
  cmd.start_with?('scriv') || cmd.prepend('scriv ')
  CLI::Test.run_command(cmd, touches, options)
end
alias :run_command :run_commande

# Retourne le path complet (et absolu) d'un fichier se trouvant dans le
# dossier ./test/assets. +relpath+ est le chemin relatif depuis ce dossier.
def asset_path_for relpath
  File.join(APPFOLDER,'test','assets',relpath)
end

class CLI
class Test
class << self
  # À exécuter AVANT tous les tests (en passant par la commance `scriv test`)
  def before_all
    File.exist?(lasts_path) && FileUtils.move(lasts_path, lasts_path_copie)
  end
  # À exécuter APRÈS tous les tests (en passant par la commance `scriv test`)
  def after_all
    File.exist?(lasts_path_copie) && FileUtils.move(lasts_path_copie, lasts_path)
  end
  def lasts_path
    @lasts_path ||= Scrivener.last_projects_path_file
  end
  def lasts_path_copie
    @lasts_path_copie ||= "#{Scrivener.last_projects_path_file}-COPIE"
  end
end #/<< self
end #/Test
end #/CLI
