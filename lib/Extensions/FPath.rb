# encoding: UTF-8
=begin

  Utilities for application files

Version 0.0.1

  @usage

    class ClassInh
      extends ModuleFPath
      ...
      def path
        @path ||= path/to/app/folder
      end
    end

  Make a Fpath

    fp = ClassInh.fpath('path','to','file')
    # => "/Users/home/to/app/folder/path/to/file"

    fp.ext('rb')
    # => "/Users/home/to/app/folder/path/to/file.rb"

    fp.exist? #=> true/false
    fp.read   # => return contents

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

    def ext extension
      self.end_with?('.%s' % extension) || self.replace(self + '.' + extension)
    end
    def exist?
      File.exist?(self)
    end
    def read
      exist? && File.read(self)
    end

  end #/FPath

end #/ module@


if $0 == __FILE__
  require 'test/unit'
  class TestModuleFPath < Test::Unit::TestCase
    class MonAppAvecPath
      extend ModuleFPath
      def self.path
        @@path ||= File.join(Dir.home,'monApp')
      end
    end
    class MonAppSansPath
      extend ModuleFPath
    end
    class MonBureau
      extend ModuleFPath
      def self.path ; Dir.home end
    end
    test "On peut instancier avec une class qui définit :path" do
      rf = MonAppAvecPath.fpath('pour','voir')
      assert_equal('/Users/philippeperret/monApp/pour/voir', rf)
    end
    test "On ne peut pas instancier sans path" do
      assert_raise { MonAppSansPath.fpath('pour','voir') }
    end
    test "On peut instancier avec une extension" do
      rf = MonAppAvecPath.fpath('pour','voir').ext('rb')
      exp = File.join(Dir.home,'monApp', 'pour', 'voir.rb')
      assert_equal(exp, rf)
      rf = MonAppAvecPath.fpath('pour','voir').ext('yaml')
      exp = File.join(Dir.home,'monApp', 'pour', 'voir.yaml')
      assert_equal(exp, rf)
    end
    test "La méthode exist? renvoie true/false suivant l'existence" do
      rf = MonBureau.fpath('')
      assert rf.exist?
      rf = MonBureau.fpath('un/fichier/qui/ne/peut/pas/exister.mauvais')
      assert_false rf.exist?
      assert_false rf.read
    end
  end
end
