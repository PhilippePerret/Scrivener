# encoding: UTF-8
=begin

  Commande qui liste toutes les commandes

=end
thisfolder = File.expand_path(File.dirname(__FILE__))

with_short_description = CLI.options[:help]
indentation = ' ' * 12
width_short = 60
dtruncate   = {indent: indentation}.freeze

CLI::Screen.clear
wt('commands.titles.command_list.cap', nil, {air: true, underlined: '='})
Dir["#{thisfolder}/*.rb"].sort.each do |cmd|
  cmd = cmd.affixe
  puts INDENT_TIRET + cmd
  if with_short_description
    short_description = t('commands.overviews.%s' % cmd)
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
