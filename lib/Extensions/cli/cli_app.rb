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
    'dernières'   => 'last',
    'tdm'         => 'pagination',
    'toc'         => 'pagination'
  }
  # Les versions courtes communes à toutes les applications
  DIM_OPT_TO_REAL_OPT = {
    'h'               => 'help',
    'o'               => 'output',
    'u'               => 'update',
    'v'               => 'verbose',
    'w'               => 'warning'
  }
  # Les versions courtes propres à l'application courante
  # Elles peuvent surclasser des options précédemment définies
  DIM_OPT_TO_REAL_OPT.merge!({
    'bm'              => 'benchmark',
    'doc'             => 'document',
    'f'               => 'force',
    'fc'              => 'force_calcul',
    'fdc'             => 'final-draft-coefficient',
    'i'               => 'initial',
    'k'               => 'keys_mode_test',
    'l'               => 'local',
    'm2m'             => 'maxtomin',
    'N'               => 'no_count',
    't'               => 'tableau',

    'now'             => 'today'
  })
end#/CLI
