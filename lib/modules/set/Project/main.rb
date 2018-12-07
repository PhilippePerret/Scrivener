# encoding: UTF-8
class Scrivener

  ERRORS.merge!(
    unknown_method: 'La propriété `%s`, si elle existe, ne peut être définie avec la commande `set`.'
  )

class Project

  # ---------------------------------------------------------------------
  # CLASSE
  class << self
    # = main =
    #
    # Méthode principale pour exécuter la commande `set`
    def exec_set
      unless CLI.options[:help]
        project.set_values
      else
        project.help_command_set
      end
    end
    # /exec_set
  end #/<< self

  # ---------------------------------------------------------------------
  # INSTANCE

  # ---------------------------------------------------------------------
  # Méthode utilitaires

  # main
  #
  # Méthode principale appelée par la méthode Scrivener::Project::exec_set
  # qui boucle sur toutes les clés et appelle les méthodes pour enregistrer
  # les données.
  def set_values
    # puts "Je dois définir la valeur de #{keys_to_set.pretty_join}"
    puts NOTICES[:require_project_closed].bleu
    keys_to_set.each do |key, value|
      method = ('set_%s' % key.to_s).to_sym
      if self.respond_to?(method)
        send(method, value)
      else
        puts (ERRORS[:unknown_method] % key).rouge
      end
    end
    # On peut sauver tous les fichiers modifiés du projet
    # NOTE : Pour le moment, je mets tous les fichiers ici
    ui_plist.modified?    && ui_plist.save
    compile_xml.modified? && compile_xml.save
    ui_common.modified?   && ui_common.save
  end

  def keys_to_set
    @keys_to_set ||= begin
      CLI.params.keys.select{|k| k.is_a?(Symbol)}.collect do |k|
        [TABLE_EQUIVALENCE_DATA_SET[k] || k, CLI.params[k].to_s.strip]
      end
    end
  end
end #/Project
end #/Scrivener
