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
  class Scrivener
ERRORS.merge!(
  build_thing_required: 'Il faut définir la chose à construire en deuxième argument. P.e. `scriv build documents ...`',
  build_invalid_thing:  '"%s" est une chose à construire invalide (choisir parmi %s).'
)
  class Project
    BUILDABLE_THINGS = {
    documents:  {hname: 'documents'},
    tdm:        {hname: 'table des matières'},
    metadatas:  {hname: 'metadatas'}
    }
  class << self
    def exec_build_thing thing
      # Cette "thing" est-elle valide
      thing || raise_thing_required
      thing = thing.strip.downcase.to_sym
      is_thing?(thing)  || raise_invalid_thing

      # On peut lancer l'opération
      Scrivener.require_module('Scrivener')
      Scrivener.require_module('build/%s' % thing)
      Scrivener::Project.exec_build
    end
    # Return true si +thing+ est une chose constructible
    def is_thing?(thing)
      BUILDABLE_THINGS.key?(thing)
    end
    def raise_thing_required
      raise(ERRORS[:build_thing_required])
    end
    def raise_invalid_thing(thing)
      raise(ERRORS[:build_invalid_thing] % thing)
    end

  end #/<< self
  end #/Project
  end #/Scrivener
  Scrivener::Project.exec_build_thing(CLI.params[1])
end
