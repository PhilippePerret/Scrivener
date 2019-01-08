# encoding: UTF-8
class Scrivener
  class Project

    include XMLModule

    # Le fichier Settings/compile.xml
    #
    # Ce fichier contient quelques informations intéressantes, comme les
    # titres des documents ou les auteurs.
    #
    def compile_xml
      @compile_file ||= XMLCompile.new(self, compile_file_path) #XML.new(self, compile_file_path)
    end

    class XMLCompile < XML

      # Formats de sortie possibles
      # La clé doit être la valeur que peut fournir un utilisateur, mise en
      # minuscule. La `:value` doit être la valeur à enregistrer dans le
      # fichier XML.
OUTPUT_FORMATS = {
  pdf:            {value: 'pdf'            , hname: 'PDF'},
  print:          {value: 'Print'          , hname: 'Print'},
  rtf:            {value: 'rtf'            , hname: 'RTF'},
  rtfd:           {value: 'rtfd'           , hname: 'RTFD'},
  docx:           {value: 'docx'           , hname: 'Microsoft Word (X)'},
  doc:            {value: 'doc'            , hname: 'Microsoft Word'},
  odt:            {value: 'odt'            , hname: 'LibreOffice/OpenOffice'},
  txt:            {value: 'txt'            , hname: 'Simple text'},
  html:           {value: 'html'           , hname: 'Page web'},
  fdx:            {value: 'fdx'            , hname: 'Final Draft'},
  fountain:       {value: 'Fountain'       , hname: 'Scénario Fountain'},
  epub3:          {value: 'epub3'          , hname: 'ePub'},
  multimarkdown:  {value: 'mmd'            , hname: 'MultiMarkdown'},
  mmd_latex:      {value: 'mmd-latex'      , hname: 'MultiMarkdown vers LaTex'},
  mmd_office:     {value: 'mmd-odt'        , hname: 'MultiMarkdown vers LibreOffice'},
  mmd_html:       {value: 'mmd-html'       , hname: 'MultiMarkdown vers HTML'},
  mmd_odf:        {value: 'mmd-odf'        , hname: 'MultiMarkdown vers flat-XML'},
  mmd_pdf:        {value: 'mmd-pdf'        , hname: 'MultiMarkdown vers PDF'},
  pandoc_docx:    {value: 'pandoc-docx'    , hname: 'PanDoc vers Microsoft WordX'},
  pandoc_docbook: {value: 'pandoc-docbook' , hname: 'PanDoc vers DocBook'},
  pandoc_epub:    {value: 'pandoc-epub'    , hname: 'PanDoc vers ePub'}
}

      def remove_comments?
        options.elements['RemoveComments'].text == 'Yes'
      end
      def remove_comments= value
        XML.get_or_add(options, 'RemoveComments').text = value
      end

      def remove_annotations?
        options.elements['RemoveAnnotations'].text == 'Yes'
      end
      def remove_annotations= value
        XML.get_or_add(options, 'RemoveAnnotations').text = value
      end

      # 'Print' ou 'Pdf'
      def output_format
        root.elements['CurrentFileType'].text
      end

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
      REXML::XPath.each(compile_xml.docxml, '//MetaData/Authors/Author').collect do |n|
        get_author_info_from_node(n)
      end
    end

    def get_author
      # On essaie d'abord d'obtenir les informations par les data Surname et
      # Forename.
      nom     = compile_xml.get_xpath('//MetaData/Surname')
      prenom  = compile_xml.get_xpath('//MetaData/Forename')

      unless (nom+prenom).empty?
        {firstname: prenom, lastname: nom, role: 'aut'}
      else
        get_author_info_from_node(compile_xml.metadata.elements['Authors'].elements['Author'].first)
      end
    end

    def define_author dauteur
      XML.get_or_add(compile_xml.metadata, 'Surname').text = dauteur[:lastname]
      XML.get_or_add(compile_xml.metadata, 'Forename').text = dauteur[:firstname]
      compile_xml.set_modified
    end

    def get_author_info_from_node n
      nom, prenom =
        n.attributes['FileAs'] ? n.attributes['FileAs'].split(',') : [n.text, '']
      {firstname: prenom.strip, lastname: nom.strip, role: n.attributes['Role']}
    end


    def options
      @get_options ||= compile_xml.options
    end

  end #/Project
end #/Scrivener
