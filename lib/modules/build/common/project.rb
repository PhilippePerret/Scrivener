# frozen_string_literal: true
# encoding: UTF-8
=begin
  Module pour la commande 'build'
=end

class Scrivener
class Project
  BUILDABLE_THINGS = {documents:          {hname: t('document.min.plur')},
                      tdm:                {hname: t('table_of_contents.min.plur')},
                      metadatas:          {hname: t('metadata.min.plur')},
                      :'config-file' =>   {hname: t('config_file.tit.sing')}
                    }
end #/Project
end #/Scrivener
