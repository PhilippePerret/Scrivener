class Scrivener
  class Project

    def load_modules_proximites

      # On commence par requérir tous les modules du module 'proximites'
      # utiles à cette commande (tous ?)
      # Les dossiers
      ['BinderItem', 'Proximite/class', 'Prox_mot', 'Lemmatisation'].each do |folder|
        Dir["#{APPFOLDER}/lib/modules/prox/proximites/#{folder}/**/*.rb"].each{|m| require m}
      end
      # Les fichiers séparés
      temp_required = '%s/lib/modules/prox/proximites/%s' % [APPFOLDER, '%s']
      [
        'Proximite/instance/instance',
        'Proximite/lists_constants',
        'Lemmatisation/peuple_table_lemma.rb',
        'Lemmatisation/lemmatize.rb',
      ].each do |pfile|
        require temp_required % pfile
      end
    end
    # /check_etat_proximites_et_affiche_differences

  end #/Project
end #/Scrivener
