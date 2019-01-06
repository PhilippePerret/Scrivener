# encoding: UTF-8
=begin
  Command 'build' pour voir les infos générales du projet courant

  C'est l'aide générale du site
=end
if CLI.options[:help]
  Scrivener.require_texte('aide_generale_build_command')
  full_aide = AideGeneraleBuildCommand::AIDE.dup
  # On peut ajouter une aide si l'objet à construire est déjà
  # déterminé (par exemple `scriv build metadata -h`)
  full_aide <<  case CLI.params[1]
                when 'documents', 'document'
                  Scrivener.require_texte('aide_build_document_command')
                  BuildDocumentCommandHelp::AIDE
                when 'metadata', 'metadatas'
                  Scrivener.require_texte('aide_build_metadata_command')
                  BuildMetadataCommandHelp::AIDE
                else
                  ''
                end

  # On peut écrire l'aide complète
  Scrivener.help(full_aide)

else
  # Si ce n'est pas l'aide qui est demandée
  class Scrivener
  class Project
  class << self
    def exec_build_thing thing
      # On a besoin des librairies, qui contiennent notamment les
      # message d'erreur.
      Scrivener.require_module('Scrivener')
      Scrivener.require_module('build/common')
      # Cette "thing" est-elle valide
      thing || raise_thing_required
      thing = thing.strip.downcase.to_sym
      is_thing?(thing)  || raise_invalid_thing(thing)
      Scrivener.require_module('build/%s' % thing)

      # On peut lancer l'opération
      Scrivener::Project.exec_build
    end
    # Return true si +thing+ est une chose constructible
    def is_thing?(thing)
      BUILDABLE_THINGS.key?(thing)
    end

    # Permet par exemple d'utiliser 'tdm' à la place de 'documents'
    def real_thing(thing)
      thing = 'documents' if thing == 'tdm'
      return thing
    end

  end #/<< self
  end #/Project
  end #/Scrivener
  Scrivener::Project.exec_build_thing(Scrivener::Project.real_thing(CLI.params[1]))
end
