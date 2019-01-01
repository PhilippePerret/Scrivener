# encoding: UTF-8
class Scrivener
class Project

  # Path du fichier du projet (qui sert à son instanciation)
  attr_reader :path

  # l'UUID du dossier courant dans lequel doit être placé
  # le document courant, ou nil
  # # TODO Il faudrait se passer de cette propriété, maintenant
  # # qu'on sait créer un binder-item n'importe où.
  # attr_accessor :current_folder

  def title
    @title || get_long_title
  end

  def title_abbreviated
    @title_abbreviated ||= get_abbreviate_title
  end

  def authors
    @authors ||= get_authors
  end

  # Date de dernière modification du projet
  def modified_at
    @modified_at ||= File.stat(path).mtime
  end

  def define_custom_metadata_if_needed(hdata)
    unless self.respond_to?(:custom_metadatas?)
      Scrivener.require_module('build/metadata')
      extend BuildMetadataModule
    end
    get_or_create_custom_metadatas(hdata)
  end
  # /define_custom_metadata_if_needed

end #/Project
end #/Scrivener
