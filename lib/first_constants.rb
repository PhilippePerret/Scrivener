# frozen_string_literal: true
# encoding: UTF-8

APPFOLDER = File.expand_path(File.dirname(__dir__))

HOME_FOLDER = File.join(Dir.home,'.scriv')
`mkdir -p "#{HOME_FOLDER}"` # créé au besoin

FRENCH_SPACE = ENV['SCRIV_LANG'] == 'fr' ? ' ' : ''
