# frozen_string_literal: true
# encoding: UTF-8
=begin
=end
class Scrivener
class Project
class << self

  def exec_build thing = nil
    include BuildConfigFileModule
    project.exec_building
  end

end #/<< self
end #/Project
end #/Scrivener
