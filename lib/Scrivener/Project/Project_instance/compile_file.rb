# encoding: UTF-8
class Scrivener
  class Project

    # Le fichier Settings/compile.xml
    #
    # Ce fichier contient quelques informations intéressantes, comme les
    # titres des documents ou les auteurs.
    #
    def compile_xml
      @compile_file ||= XML.new(compile_file_path)
    end

    def get_long_title
      compile_xml.metadata.elements['ProjectTitle'].text
    end

    def get_abbreviate_title
      compile_xml.metadata.elements['ProjectAbbreviatedTitle'].text
    end


    class XML
      attr_accessor :path
      def initialize path
        self.path = path
      end
      def docxml
        @docxml ||= REXML::Document.new(File.new(path))
      end
      def root ; @root ||= docxml.root end
      def metadata
        @metadata ||= begin
          # n = root.elements['CompileSettings']elements['Metadata'].first
          REXML::XPath.first(docxml, '//MetaData')
        end
      end
    end

  end #/Project
end #/Scrivener
