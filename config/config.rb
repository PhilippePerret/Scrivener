
# MODE_DEVELOPPEMENT = false
MODE_DEVELOPPEMENT = File.basename(Dir.home) == 'philippeperret'

CLI.debug_output = :log

# Langue utilisée par défaut
ENV['SCRIV_LANG'] = 'fr'

ENV['SCRIV_EDITOR'] = 'TextMate'
# ENV['SCRIV_EDITOR'] = 'vim'

# Mettre ici le path du dossier TreeTagger qui permet la lemmatisation
# du texte. Ce dossier est important, notamment, pour éditer les
# abbréviations
#
FOLDER_TREE_TAGGER_PATH = File.join('/','usr','local','TreeTagger')
TREE_TAGGER_ABBREVIATES = File.join(FOLDER_TREE_TAGGER_PATH,'lib','french-abbreviations')
