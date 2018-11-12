#!/usr/bin/env ruby
=begin

  Jouer ce script (CMD-i dans Atom, CMD-r dans TextMate) pour
  construire le lien symbolique qui permet de lancer le script en
  ligne de commande.

=end

require 'fileutils'

THISFOLDER = File.expand_path(__dir__)

bin_local_folder    = File.join('/','usr','local','bin')
scriv_command_path  = File.join(bin_local_folder, 'scriv')
script_path         = File.join(THISFOLDER,'scriv.rb')

existe_deja = true # File.exist? est inopérant

File.unlink(scriv_command_path) if existe_deja
# Par lien symbolique
`chmod a+x "#{script_path}"`
`ln -sf "#{script_path}" #{scriv_command_path}`
# -s => lien symbolique
# -f => détruit le lien s'il existe


puts "Commande `scriv' #{existe_deja ? 'actualisée' : 'installée'}."
