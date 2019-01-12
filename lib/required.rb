# encoding: UTF-8
require 'fileutils'
require 'yaml'
require 'plist'

require_relative 'first_constants'

[
  File.join('lib','Extensions'),
  File.join('lib','Scrivener')
].each do |relpath|
  fpath = File.join(APPFOLDER,relpath,'**','*.rb')
  Dir[fpath].each{|m|require m}
end

[
  'config/config',
  'config/environment'
].each do |relpath|
  require File.join(APPFOLDER,relpath.split('/'))
end
