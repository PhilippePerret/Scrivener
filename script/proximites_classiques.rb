# encoding: UTF-8
=begin

RÉFLEXION
Est-ce qu'il ne serait pas plus intéressant, pour le découpage, de remplacer
les éléments qu'on trouvera au fur et à mesure de leur remplacement.

Par exemple, on cherche tous les "Chapitres XXXX" en même temps que tous
les "PARTIE XXXX" OU "XXXXX PARTIES" et on les remplace par une marque
de découpage qui contiendra le titre envisagé.

Donc : on prend le texte entier, on le parcours

=end
class FileAlreadyTreated < StandardError; end

RC = String::RC

Scrivener.require_module('Scrivener')
Scrivener.require_module('prox')
Scrivener.require_module('lib/proximites')


# = Dossier contenant les fichiers =
FOLDER_TEXTES = File.join(Dir.home,'Documents','Ecriture','Analyses')
FOLDER_CLASSIQUES = File.join(Dir.home,'Documents','Ecriture','Analyses','Classiques')
FOLDER_TEXTES_CONNUS = File.join(Dir.home,'Documents','Ecriture','Analyses','Textes_reputes')


# ---------------------------------------------------------------------

# Méthode principale pour traiter le livre
def check_proximites_of ppath
  puts RC*2 + ('*** Traitement de : %s' % ppath)
  Scrivener::Project.current= Scrivener::Project.new(ppath)
  project.check_proximites
rescue FileAlreadyTreated => e
  puts e.message.bleu
  false
rescue Exception => e
  puts e.message.rouge
  puts e.backtrace[0...5].join(RC)
  raise
else
  puts "Projet « #{project.title} » traité avec succès (en tout cas j'espère).".bleu
  true
end
# /formate_livre_of_path


# Dir["#{FOLDER_TEXTES_CONNUS}/**/*.scriv"].each_with_index do |ppath, index_path|
Dir["#{FOLDER_TEXTES}/**/*.scriv"].each_with_index do |ppath, index_path|
  if check_proximites_of(ppath)
    # index_path < 5 || break
    # break # s'arrêter au premier
  end
end
