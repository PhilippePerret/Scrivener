=begin
  Ce fichier doit être chargé par tous les tests en ajoutant en haut du
  fichier :

    require './test/tests_helper'

  Pour lancer le test :

    CMD-I s'il est est affiché dans Atom

    ruby ./test/* <options> # dans la console.

    On peut régler le niveau de verbosité avec :
    -v, --verbose=[LEVEL]            Set the output level (default is verbose).
                                    (important-only, n[ormal], p[rogress], s[ilent], v[erbose])

    Avec --verbose=s on a rien
    Avec --verbose=n, on a le retour d'erreur un peu détaillé
    Avec --verbose=p, on a juste les F et les *

=end
# require 'pty'
require 'test/unit'

# Il faut requérir tous les requirements de l'application, notamment pour
# les données enregistrées dans les fichiers Marshal
require './lib/required'
CLI.init # notamment pour que CLI.options ne soit pas nil

Dir['./test/support/**/*.rb'].each{|m| require m}

puts "\n\n\n\n"

# +touches+ est la liste des touches à jouer interactivement.
def run_commande cmd, touches = nil
  cmd.start_with?('scriv ') || cmd.prepend('scriv ')
  if touches
    touches.is_a?(Array) || touches = [touches]
    touches = touches.join(';;;')
    cmd << ' -k="%s"' % touches
  end
  # puts "Commande jouée : #{cmd.inspect}"
  `#{cmd}`
end
