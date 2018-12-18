# encoding: UTF-8
require_relative '../../lib/xml_module'
class Scrivener
  class Project

    include XMLModule

    # Le fichier Settings/compile.xml
    #
    # Ce fichier contient quelques informations intéressantes, comme les
    # titres des documents ou les auteurs.
    #
    def compile_xml
      @compile_file ||= XML.new(self, compile_file_path)
    end

    # ---------------------------------------------------------------------
    # Méthodes pour obtenir les infos

    def get_long_title
      compile_xml.metadata && compile_xml.metadata.elements['ProjectTitle'].text
    end

    def get_abbreviate_title
      compile_xml.metadata && compile_xml.metadata.elements['ProjectAbbreviatedTitle'].text
    end

    # Retourne la liste des auteurs
    # C'est un Array contenant des Hash {:firstname, :lastname, :role}
    def get_authors
      # # Ne retourne pas tous les auteurs mais seulement le premier :
      # compile_xml.metadata.elements['Authors'].elements['Author'].collect {|n| n.value}

      # Retourne bien tous les auteurs
      REXML::XPath.each(compile_xml.docxml, '//MetaData/Authors/Author').collect do |n|
        nom, prenom =
          n.attributes['FileAs'] ? n.attributes['FileAs'].split(',') : [n.text, '']
        {firstname: prenom.strip, lastname: nom.strip, role: n.attributes['Role']}
      end

    end

    def remove_comment?
      compile_xml.options.elements['RemoveComments'].text == 'Yes'
    end
    def remove_annotations?
      compile_xml.options.elements['RemoveAnnotations'].text == 'Yes'
    end

    def options
      @get_options ||= compile_xml.options
    end

  end #/Project
end #/Scrivener
