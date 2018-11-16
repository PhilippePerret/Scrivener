# encoding: UTF-8
=begin

  Module fonctionnement avec le module cli.rb qui permet de définir, pour
  l'application propre, la conversion des diminutifs.

=end

class CLI
  # Raccourcis pour les commandes
  DIM_CMD_TO_REAL_CMD = {
    'prox'        => 'proximites',
    'watch-prox'  => 'watch-proximites'
  }
  DIM_OPT_TO_REAL_OPT = {
    'bm'              => 'benchmark',
    'doc'             => 'document',
    'f'               => 'force',
    'fc'              => 'force_calcul',
    'fdc'             => 'final-draft-coefficient',
    'h'               => 'help',
    'k'               => 'keys_mode_test',
    'o'               => 'output',
    'vb'              => 'verbose',

    'now'             => 'today'
  }
end#/CLI
