# encoding: UTF-8
=begin

  Commande qui liste toutes les commandes

=end
thisfolder = File.expand_path(File.dirname(__FILE__))

puts String::RC * 2
Dir["#{thisfolder}/*.rb"].sort.each do |cmd|
  puts '  - %s' % File.basename(cmd, File.extname(cmd))
end
puts String::RC * 2
puts '(utiliser `scriv <commande> -h` ou `scriv <commande> --help` pour obtenir de l’aide sur la commande "<commande>")'
puts String::RC * 2
