# frozen_string_literal: true
# encoding: UTF-8
class Scrivener
class Project

  # = main =
  #
  # Méthode principale appelée par la méthode Scrivener::Project::exec_set
  # quand l'option --from est utilisée, qui détermine le fichier à charger
  # qui contient les données à affecter.
  #
  def set_values_from_file
    file_yaml_exists_or_raise
    YAML.load(File.read(yaml_file)).each do |key, value|
      method = ('set_%s' % real_setter_key(key.to_sym)).to_sym
      if self.respond_to?(method)
        begin
          send(method, value)
        rescue Exception => e
          puts INDENT_TIRET + e.message.rouge
        end
      else
        wt('commands.set.errors.unknown_set_method', {prop: key}, {color: :rouge})
      end
    end
  end


  # ---------------------------------------------------------------------
  #   Méthodes fonctionnelles

  def yaml_file
    @yaml_file ||= begin
      yf = CLI.options[:from].to_s
      File.expand_path(File.join(folder, yf.with_extension('yaml')))
    end
  end

  def file_yaml_exists_or_raise
    File.exist?(yaml_file) || rt('files.errors.yaml_file_unfound', {pth: yaml_file}, IOError)
  end
  # /file_yaml_exists_or_raise
  private :file_yaml_exists_or_raise

end #/Project
end #/Scrivener
