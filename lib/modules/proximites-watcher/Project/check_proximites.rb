class Scrivener
  class Project

    def check_etat_proximites_et_affiche_differences
      puts "-> check des proximités"

      # On commence par requérir tous les modules du module 'proximites'
      # utiles à cette commande (tous ?)
      ['BinderItem'].each do |folder|
        Dir["./lib/modules/proximites/#{folder}/**/*.rb"].each{|m| require m}
      end
    end
    # /check_etat_proximites_et_affiche_differences

  end #/Project
end #/Scrivener
