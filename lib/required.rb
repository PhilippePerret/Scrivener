# encoding: UTF-8
require 'fileutils'
require 'yaml'
require 'plist'

# APPFOLDER = File.expand_path(File.dirname(File.dirname(__FILE__)))
APPFOLDER = File.expand_path(File.dirname(__dir__))

Dir["#{APPFOLDER}/lib/Extensions/**/*.rb"].each{|m|require m}
Dir["#{APPFOLDER}/lib/Scrivener/**/*.rb"].each{|m|require m}
Dir["#{APPFOLDER}/config/**/*.rb"].each{|m|require m}
