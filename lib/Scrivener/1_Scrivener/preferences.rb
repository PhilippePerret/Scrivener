# frozen_string_literal: true
# encoding: UTF-8
=begin
  Module pour gérer les préférences
  Les préférences sont maintenus dans un fichier $HOME/.scriv/prefs.yaml
=end
class Scrivener
class << self

  def preferences
    @preferences ||= Preferences.new()
  end

end #/ << self

class Preferences

  # +hdata+     Hash des données à modifier
  # +options+
  #   :save     Enregistre les préférences si true
  def set hdata, options = nil
    options ||= Hash.new
    @data = data.merge(hdata)
    save if options[:save]
  end

  def get prop
    data[prop.to_sym]
  end
  alias :[] :get

  def data
    @data ||= begin
      exist? ? load : default_data
    end
  end

  def default_data
    {
      lang: (ENV['SCRIV_LANG'] || 'en')
    }
  end

  def exist?
    File.exist?(file_path)
  end

  def load
    YAML.load(File.read(file_path), symbolize_keys: true)
  end

  def save
    code = YAML.dump(data) # surtout pour éviter les problèmes d'accès
    File.open(file_path,'wb'){|f| f.write(code)}
  end

  def file_path
    @file_path ||= File.join(HOME_FOLDER,'prefs.yaml')
  end

  # Pour les tests
  def reset
    @data       = nil
    @file_path  = nil
  end

end #/Preferences
end #/Scrivener
