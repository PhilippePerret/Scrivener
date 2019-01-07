#!/usr/bin/env ruby
=begin

  Jouer ce script (CMD-i dans Atom, CMD-r dans TextMate) pour
  construire le lien symbolique qui permet de lancer le script en
  ligne de commande.

  ATTENTION : POUR FAIRE LA VERSION "FINALE" (CELLE DANS LE DOSSIER
  APPLICATION) IL FAUT METTRE MODE_DEVELOPPEUR CI-DESSOUS À FALSE
  AVANT DE LANCER CE MODULE.

=end

# Nom de la commande CLI (doit correspondre au fichier qui se trouve
# au même niveau que ce module et qui lance et gère la commande)
APPNAME = 'scriv'
# Le dossier dans lequel sera copié le code, dans le dossier Applications (car
# s'il n'est pas dans le dossier applications, il ne peut être partagé par
# différents utilisateurs)
FOLDER_IN_APPS = 'Scrivener_CLI'

# ---------------------------------------------------------------------
# Ne rien toucher sous cette ligne

# En mode développeur (quand c'est moi), je crée la commande scriv pour
# quelle pointe sur le dossier de développement
MODE_DEVELOPPEUR = File.basename(Dir.home) == 'philippeperret'
# MODE_DEVELOPPEUR = false

require 'fileutils'
THISFOLDER = File.expand_path(__dir__)
# puts "THISFOLDER: #{THISFOLDER.inspect}"
SCRIVFOLDER = File.expand_path('.')
# puts "SCRIVFOLDER: #{SCRIVFOLDER.inspect}"

unless MODE_DEVELOPPEUR
  puts "Je copie le dossier. Merci de patienter…"
  FOLDER_DEST = File.join('/', 'Applications', FOLDER_IN_APPS, '/')
  FileUtils.rm_rf(FOLDER_DEST) if File.exist?(FOLDER_DEST)
  FileUtils.cp_r(SCRIVFOLDER, FOLDER_DEST)
  script_path = '/Applications/Scrivener_CLI/bin/scriv.rb'
else
  script_path = File.join(SCRIVFOLDER,'bin',"#{APPNAME}.rb")
end

bin_local_folder  = File.join('/','usr','local','bin')
app_command_path  = File.join(bin_local_folder, APPNAME)
`rm "#{app_command_path}"`

# Par lien symbolique
`chmod a+x "#{script_path}"`
`ln -sf '#{script_path}' #{app_command_path}`
# -s => lien symbolique
# -f => détruit le lien s'il existe


puts "Commande `#{APPNAME}' installée."
