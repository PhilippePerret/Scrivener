# frozen_string_literal: true
# encoding: UTF-8

# MODE_DEVELOPPEMENT = false
MODE_DEVELOPPEMENT = File.basename(Dir.home) == 'philippeperret'

CLI.debug_output = :log

# Langue utilisée par défaut
# TODO La prendre des préférences utilisateur
ENV['SCRIV_LANG'] ||= (Scrivener.preferences[:lang] || 'en').to_s
# ENV['SCRIV_LANG'] ||= 'en'

ENV['SCRIV_EDITOR'] = 'TextMate'
# ENV['SCRIV_EDITOR'] = 'vim'

# Mettre ici le path du dossier TreeTagger qui permet la lemmatisation
# du texte. Ce dossier est important, notamment, pour éditer les
# abbréviations
#
FOLDER_TREE_TAGGER_PATH = File.join('/','usr','local','TreeTagger')
TREE_TAGGER_ABBREVIATES = File.join(FOLDER_TREE_TAGGER_PATH,'lib','french-abbreviations')


I18n.load_path << Dir[File.join(APPFOLDER,'config','locales','**','*.yml')]
I18n.available_locales = [:en, :fr, :de]
I18n.default_locale = ENV['SCRIV_LANG'].to_sym # (note that `en` is the default!)


# puts '= LANG: %s' % ENV['SCRIV_LANG']
