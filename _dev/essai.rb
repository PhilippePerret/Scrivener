# encoding: UTF-8
=begin

Version 0.0.1

  @usage
    class ClassInh
      extends ModuleFPath
      ...
    end

  Make a Fpath

    fp = ClassInh.fpath('path','to','file')

    fp # => "/to/app/folder/path/to/file"
    fp.exist? #=> true/false

# Version 0.0.1
    Mise en place avec seulement la méthode exist?

=end
module ModuleFPath

  def fpath *rel_path
    FPath.new(File.join(path,rel_path))
  end

  class FPath < String
    def initialize v
      super(v)
    end

    def exist?
      File.exist?(self)
    end

  end #/FPath

end #/ module

APPFOLDER = File.join('/Users/philippeperret/Programmation/Scrivener')

class Scrivener
  extend ModuleFPath
  def self.path
    @@path ||= APPFOLDER
  end
end #/Scrivener


p = Scrivener.fpath('_dev','essai.rb')

puts "p = #{p}"
puts "p = " + p
puts "p existe : #{p.exist?.inspect}"
