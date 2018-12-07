# encoding: UTF-8


Scrivener.require_module('Scrivener')


FOLDER_CLASSIQUES = File.join(Dir.home,'Documents','Ecriture','Analyses','Classiques')
ppath = File.join(FOLDER_CLASSIQUES,'Divers','Britannicus','Britannicus.scriv')

Scrivener::Project.current= Scrivener::Project.new(ppath)

project.binder_items.count == 1 || begin
  raise 'Il semble que ce projet soit déjà traité. Il possède plus d’un fichier'
end

bitem_texte = project.binder_items.first

puts '-- TITRE: %s' % bitem_texte.title

# '-------- FIN DU FICHIER '

# TODO
# Renommer le fichier 'Recherche' par 'Divers'

# TODO
# On va découper le fichier suivant sa licence, son entête et son texte dans
# un premier temps
# La licence doit faire un nouveau fichier dans le dossier
start_licence = '(.*?)CONSERVEZ CETTE LICENCE(.*?)'
end_licence   = '(.*?)---- FIN DE LA LICENCE (.*?)'
start_entete  = '--- ATTENTION : CONSERVEZ CET EN-TETE (.*?)'
end_entete    = '(.*?)--- FIN DE L\'EN-TETE(.*?)'
start_texte   = '------------------------- DEBUT DU FICHIER ([^ ]+) --------------------------------'
end_texte     = '------------------------- FIN DU FICHIER %{titre_texte} --------------------------------' % {titre_texte: titre_texte}
