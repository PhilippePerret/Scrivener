# encoding: UTF-8
class Scrivener
class Project

  # Path du fichier du projet (qui sert à son instanciation)
  attr_reader :path

  def title
    @title || get_long_title
  end

  def title_abbreviated
    @title_abbreviated ||= get_abbreviate_title
  end

  # Auteurs du projet, s'ils sont définis
  def authors
    @authors ||= get_authors
  end

  def author
    @author ||= get_author
  end

  # Date de dernière modification du projet
  def modified_at
    @modified_at ||= File.stat(path).mtime
  end

  # Permet de définir plusieurs métadata.
  # +hdata+ Noter que c'est un Hash (table) qui définit forcément plusieurs
  # métadonnées. Elle contient { "<id métadonnée>" => {<données métadonnées>}, etc.}
  def define_custom_metadatas_if_needed(hdata)
    defined?(MetaData) || self.class.require_module_metadatas
    hdata.each do |key, md_data|
      MetaData.new(self, key, md_data).create
    end
  end
  # /define_custom_metadatas_if_needed

  def save_all
    xfile.modified?       && xfile.save
    ui_plist.modified?    && ui_plist.save
    compile_xml.modified? && compile_xml.save
    ui_common.modified?   && ui_common.save
  end
  # /save_all

  # ---------------------------------------------------------------------
  #   Méthodes fonctionnelles

  def self.require_module_metadatas
    Scrivener.require_module('build/metadatas')
    include BuildMetadatasModule
  end

end #/Project
end #/Scrivener
