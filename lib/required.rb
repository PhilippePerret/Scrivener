# encoding: UTF-8
require 'yaml'

# APPFOLDER = File.expand_path(File.dirname(File.dirname(__FILE__)))
APPFOLDER = File.expand_path(File.dirname(__dir__))

Dir["#{APPFOLDER}/lib/Extensions/**/*.rb"].each{|m|require m}
Dir["#{APPFOLDER}/lib/Scrivener/**/*.rb"].each{|m|require m}

class Scrivener
  class Project
    class << self

      attr_accessor :current

    end #/<< self
  end #/Project
end #/Scrivener

def project
  Scrivener::Project::current ||= PROJECT_PATH ? Scrivener::Project.new(PROJECT_PATH) : nil
end
alias :current_project :project

Dir["#{APPFOLDER}/config/**/*.rb"].each{|m|require m}
