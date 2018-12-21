# encoding: UTF-8
=begin

  Module fonctionnement avec le module cli.rb qui permet de définir, pour
  l'application propre, la conversion des diminutifs.

=end

class CLI
  # Raccourcis pour les commandes
  DIM_CMD_TO_REAL_CMD = {
    'prox'        => 'proximites',
    'stats'       => 'data',
    'watch-prox'  => 'watch-proximites',
    'lasts'       => 'last',
    'derniers'    => 'last',
    'dernières'   => 'last'
  }
  DIM_OPT_TO_REAL_OPT = {
    'bm'              => 'benchmark',
    'doc'             => 'document',
    'f'               => 'force',
    'fc'              => 'force_calcul',
    'fdc'             => 'final-draft-coefficient',
    'h'               => 'help',
    'i'               => 'initial',
    'k'               => 'keys_mode_test',
    'l'               => 'local',
    'm2m'             => 'maxtomin',
    'o'               => 'output',
    't'               => 'tableau',
    'u'               => 'update',
    'vb'              => 'verbose',

    'now'             => 'today'
  }
end#/CLI
