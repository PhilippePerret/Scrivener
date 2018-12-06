# encoding: UTF-8
=begin

  Commande qui liste toutes les commandes

=end
thisfolder = File.expand_path(File.dirname(__FILE__))

Dir["#{thisfolder}/*.rb"].sort.each do |cmd|
  puts '  - %s' % File.basename(cmd, File.extname(cmd))
end
