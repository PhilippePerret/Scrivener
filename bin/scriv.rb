#!/usr/bin/env ruby
# encoding: UTF-8
# On require toute la librairie Scrivener
require_relative '../lib/required'


def command_exist? cmd
  File.exist?(File.join(APPFOLDER,'lib','commands',"#{cmd}.rb"))
end

begin
  COMMAND = (CLI::DIM_CMD_TO_REAL_CMD[ARGV[0]] || ARGV[0]) || 'help'

  COMMAND || raise("Le premier argument doit définir la commande")
  command_exist?(COMMAND) || raise("La commande `#{COMMAND}` est inconnue (utilisez la commande `commands' pour obtenir la liste de toutes les commandes).")

  CLI.analyse_command_line

  # Path du projet. Il peut être fourni par :
  #   - le premier paramètre
  #   - un fichier .scriv dans le dossier courant
  #   - le dernier path utilisé
  PROJECT_PATH = Scrivener::Project.define_project_path_from_command

  VERBOSE = CLI.verbose?
rescue Exception => e
  puts e.message.rouge_gras
end

# On doit vérifier la conformité du projet (sauf si c'est une commande d'aide
# qui est demandée)
begin
  valid_command = nil

  # On doit vérifier que le path est fourni et qu'il s'agit bien d'un projet
  # scrivener
  unless COMMAND == 'help' || COMMAND == 'commands' || CLI.options[:help]
    valid_command = "scriv #{CLI.last_command} ./vers/mon/proj.scriv"
    PROJECT_PATH || raise('Il faut définir le projet Scrivener à traiter, en indiquant le chemin depuis votre dossier utilisateur (%s).' % [Dir.home])
    File.extname(PROJECT_PATH) == '.scriv'  || raise('L’extension du projet devrait être «.scriv» (c’est «%s»)' % File.extname(PROJECT_PATH))
    File.exist?(PROJECT_PATH) || raise('Le projet «%s» est introuvable. Merci de vérifier le chemin.' % PROJECT_PATH)
  end

  # On sauvegarde ces informations
  Scrivener::Project.save_project_data(last_command: COMMAND, path: PROJECT_PATH, options: CLI.options)

  # On exécute la commande
  # (dans le contexte du dossier où on se trouve)
  # -------------------
  if PROJECT_PATH
    # On n'est pas forcément dans le dossier du projet, comme par exemple
    # lorsqu'on réutilise la dernière path utilisée.
    Dir.chdir(project.folder) do
      require File.join(APPFOLDER,'lib','commands',COMMAND)
    end
  else
    require File.join(APPFOLDER,'lib','commands',COMMAND)
  end

rescue Exception => e
  puts e.message.rouge
  puts e.backtrace[0..2].join("\n").rouge
  if valid_command
    puts "Commande valide : #{valid_command}".rouge
  end
end
