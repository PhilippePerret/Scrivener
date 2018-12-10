class Scrivener

  def self.require_module module_name
    Dir['%s/lib/modules/%s/**/*.rb' % [APPFOLDER, module_name]].each{|m|require m}
  end

  # Permet de charger toutes les librairies.
  #
  # Pour le moment, cette méthode n'est utilisée que pour les tests.
  # On peut rencontrer un problème dans le sens où une méthode peut être
  # définie avec le même nom mais deux fonctions différentes dans deux
  # dossiers modules différents. On évite au maximum, mais on n'est pas
  # à l'abri de cette erreur possible.
  def self.require_all
    Dir['%s/lib/modules/**/*.rb' % [APPFOLDER]].each { |m| require m }
  end

  # Le mode actuel
  def self.mode
    if defined?(MODE_DEVELOPPEMENT) && MODE_DEVELOPPEMENT
      :development
    else
      :production
    end
  end
end #/Scrivener
