# encoding: UTF-8
require 'fileutils'
require 'i18n'
require 'yaml'
require 'plist'

# APPFOLDER = File.expand_path(File.dirname(File.dirname(__FILE__)))
APPFOLDER = File.expand_path(File.dirname(__dir__))

HOME_FOLDER = File.join(Dir.home,'.scriv')
`mkdir -p "#{HOME_FOLDER}"` # créé au besoin

[ File.join('lib','Extensions'),
  File.join('lib','Scrivener'),
  'config'].each do |relpath|
  fpath = File.join(APPFOLDER,relpath,'**','*.rb')
  Dir[fpath].each{|m|require m}
end
