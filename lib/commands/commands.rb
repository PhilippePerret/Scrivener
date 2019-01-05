# encoding: UTF-8
=begin

  Commande qui liste toutes les commandes

=end
SHORT_DESCRIPTION_COMMANDS = {
  'build'     => 'Permet de construire des éléments tels que des hiérachies de roman ou des métadonnées.',
  'check'     => 'Permet de checker l’application, à commancer par l’installation.',
  'commands'  => 'Permet de lister toutes les commandes et d’obtenir une brève description.',
  'data'      => 'Retourne toutes les données du projet, proximités, occurences, etc.',
  'help'      => 'Aide générale de la commande `scriv`.',
  'infos'     => 'Affiche les informations générales du projet.',
  'last'      => 'Affiche les derniers projets enregistrés, et permet d’en choisir un.',
  'lemma'     => 'Informations sur la lemmatisation.',
  'open'      => 'Permet d’ouvrir le projet (dans Scrivener), le dossier (dans le Finder), etc.',
  'pagination'  => 'Pour produire des tables des matières d’après le projet. Synonyme de `tdm`',
  'proximites'  => 'Procède à l’analyse textuelle du projet.',
  'run'         => 'Permet de jouer du code ruby (réservé au développement — très sensible).',
  'script'      => 'Permet de lancer un script (réservé au développement).',
  'set'         => 'Permet de définir un grand nombre de paramètres de l’application et de l’interface de Scrivener',
  'show'        => 'Affiche la chose voulue',
  'test'        => 'Lance les tests de la commande (réservé au développement)',
  'watch_proximites'  => 'Permet de suivre en direct les proximités ajoutées et corrigées dans le texte suivi.'
}
thisfolder = File.expand_path(File.dirname(__FILE__))

with_short_description = CLI.options[:help]
indentation = ' ' * 12
width_short = 60
dtruncate   = {indent: indentation}.freeze

puts String::RC * 2
Dir["#{thisfolder}/*.rb"].sort.each do |cmd|
  affixe = cmd.affixe
  puts '  - %s' % affixe
  if with_short_description
    SHORT_DESCRIPTION_COMMANDS.key?(affixe) || begin
      raise('Il faut écrire la description courte de la commande "%s".'.rouge)
    end
    short_description = SHORT_DESCRIPTION_COMMANDS[affixe]
    unless short_description.nil?
      puts indentation + String.truncate(short_description, width_short, dtruncate).join(String::RC) + String::RC*2
    end
  end
end
puts String::RC * 2
CLI.options[:help] || begin
  puts '(utiliser `scriv commands -h` pour un résumé des fonctionnalités de chaque command)'
end
puts '(utiliser `scriv <commande> -h` ou `scriv <commande> --help` pour obtenir de l’aide sur la commande "<commande>")'
puts String::RC * 2
