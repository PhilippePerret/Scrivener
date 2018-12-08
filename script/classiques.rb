# encoding: UTF-8


Scrivener.require_module('Scrivener')


FOLDER_CLASSIQUES = File.join(Dir.home,'Documents','Ecriture','Analyses','Classiques')
ppath = File.join(FOLDER_CLASSIQUES,'Divers','Britannicus','Britannicus.scriv')

Scrivener::Project.current= Scrivener::Project.new(ppath)

project.binder_items.count == 1 || begin
  raise 'Il semble que ce projet soit déjà traité. Il possède plus d’un fichier'
end

# Le fichier contenant tout le texte au départ
bitem_texte = project.binder_items.first

TITRE_DU_LIVRE = ''
# '-------- FIN DU FICHIER '

# TODO
# Renommer le dossier 'Ébauche' par le titre du livre
puts '-- Draftfolder: %s' % [project.xfile.draftfolder.attributes[:uuid]]
# Renommer le dossier 'Recherche' par 'Divers'

# TODO
# On va découper le fichier suivant sa licence, son entête et son texte dans
# un premier temps
# La licence doit faire un nouveau fichier dans le dossier
start_licence = '(.*?)CONSERVEZ CETTE LICENCE(.*?)'
end_licence   = '(.*?)---- FIN DE LA LICENCE (.*?)'
start_entete  = '--- ATTENTION : CONSERVEZ CET EN-TETE (.*?)'
end_entete    = '(.*?)--- FIN DE L\'EN-TETE(.*?)'
start_texte   = '------------------------- DEBUT DU FICHIER ([^ ]+) --------------------------------'
# => titre_texte
titre_texte ||= 'letitredutexte'
end_texte     = '------------------------- FIN DU FICHIER %{titre_texte} --------------------------------' % {titre_texte: titre_texte}
