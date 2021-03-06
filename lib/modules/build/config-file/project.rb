# frozen_string_literal: true
# encoding: UTF-8

module BuildConfigFileModule

  DEFAULT_NAME = 'config.yaml'

  def exec_building
    while File.exist?(config_file_path)
      ask_for_solution_if_exist || return
    end
    # TODO Utiliser la lang pour définir les valeurs
    lang = CLI.options[:lang] || ENV['SCRIV_LANG']
    build_new_config_file
    if CLI.options[:open]
      open_new_config_file
    else
      annonce_fin_build
    end
  end

  DEFAULT_CONFIG_LINE = '%{property}: %{default} # %{hname}'

  # Si on ne doit pas ouvrir le fichier à la fin, on indique comment le
  # voir ou l'ouvrir.
  def annonce_fin_build
    hvalues = {
      pth:      config_file_path,
      filename: config_file_name == DEFAULT_NAME ? '' : " --name=\"#{config_file_name}\""
    }
    wt('commands.build.notices.config_file_success', hvalues, {color: :bleu, air: true})
  end

  def build_new_config_file
    Scrivener.require 'lib/modules/set/Project/setters_project'
    if CLI::options[:readable]
      # On doit lire déjà toutes les propriétés uen fois pour
      # voir la longueur à adopter
      max_len = 0
      Scrivener::MODIFIABLE_PROPERTIES.each do |kprop, dprop|
        next if dprop[:not_in_yam_file]
        kprop.to_s.length > max_len || next
        max_len = kprop.to_s.length
      end
      max_len += 2
    else
      max_len = nil
    end

    begin
      rf = File.open(config_file_path,'wb')
      Scrivener::MODIFIABLE_PROPERTIES.each do |kprop, dprop|
        next if dprop[:not_in_yam_file]
        hprop = max_len ? kprop.to_s.ljust(max_len) : kprop.to_s
        rf.puts(DEFAULT_CONFIG_LINE % dprop.merge(property: hprop))
      end
    ensure
      rf.close
    end
  end

  def open_new_config_file
    if Scrivener.editor == 'vim'
      system('vim "%s"' % config_file_path)
    else
      `open -a #{Scrivener.editor} "#{config_file_path}"`
    end
  end

  # Si un fichier de même nom existe déjà, on demande quoi faire. Le supprimer
  # ou entrer une nouveau nom, qui sera lui aussi testé.
  def ask_for_solution_if_exist
    if yesOrNo(t('files.questions.replace_existant_file', {pth: config_file_path}) + ' (%s)' % [t('app.warnings.definitions_will_be_lost')])
      File.unlink(config_file_path)
      return true
    else
      @config_file_path = nil
      @config_file_name = askFor('files.questions.what_name_for_configuration_file')
    end
  end

  # Chemin d'accès au fichier de configuration. C'est soit un nom
  # par défaut (config.yaml) soit le nom précisé par l'utilisateur à
  # l'aide de l'option --name.
  def config_file_path
    @config_file_path ||= begin
      config_file_name.with_extension!('yaml')
      File.join(folder, config_file_name)
    end
  end
  def config_file_name
    @config_file_name ||= begin
      (CLI.options[:name] || CLI.options[:nom] || DEFAULT_NAME).strip
    end
  end
end #/module
