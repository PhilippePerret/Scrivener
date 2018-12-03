
# MODE_DEVELOPPEMENT = false
MODE_DEVELOPPEMENT = true

CLI.debug_output = :log


# Mettre ici le path du dossier TreeTagger qui permet la lemmatisation
# du texte. Ce dossier est important, notamment, pour éditer les
# abbréviations
#
FOLDER_TREE_TAGGER_PATH = File.join('/','usr','local','TreeTagger')
TREE_TAGGER_ABBREVIATES = File.join(FOLDER_TREE_TAGGER_PATH,'lib','french-abbreviations')