# encoding: UTF-8
=begin
  Module pour la commande 'build'
=end

class Scrivener
class Project
  BUILDABLE_THINGS = {documents:    {hname: 'documents'},
                      tdm:          {hname: 'table des matières'},
                      metadatas:    {hname: 'métadonnées'},
                      config_file:  {hname: 'Fichier de configuration'}
                    }
end #/Project
end #/Scrivener
