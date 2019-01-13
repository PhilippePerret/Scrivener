# encoding: UTF-8
class Scrivener

if help?

  require_texte('commands/build/help')
  full_aide = AideGeneraleBuildCommand::AIDE.dup
  # On peut ajouter une aide si l'objet à construire est déjà
  # déterminé (par exemple `scriv build metadata -h`)
  full_aide <<  case CLI.params[1]
                when 'documents', 'document'
                  require_texte('commands/build/aide_build_document_command')
                  BuildDocumentCommandHelp::AIDE
                when 'metadata', 'metadatas'
                  require_texte('commands/build/aide_build_metadata_command')
                  BuildMetadataCommandHelp::AIDE
                when 'config-file'
                  require_texte('commands/build/aide_build_config_file_command')
                  BuildConfigFileCommandHelp::AIDE
                else
                  ''
                end

  # On peut écrire l'aide complète
  help(full_aide)

else

  # Si ce n'est pas l'aide qui est demandée
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
      is_thing?(thing)  || rt('commands.build.errors.invalid_thing', {thing: thing})
      Scrivener.require_module('build/%s' % thing)

      # On peut lancer l'opération
      exec_build
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

  Project.exec_build_thing(Project.real_thing(CLI.params[1]))
end

end #/Scrivener
