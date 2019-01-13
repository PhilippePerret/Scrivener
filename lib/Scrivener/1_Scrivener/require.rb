class Scrivener
class << self

  # @usage: Scrivener.require('path/rel/app')
  def require module_name
    File.exist?(module_name.with_extension('rb')) || module_name = File.join(APPFOLDER, module_name)
    Kernel.require(module_name)
  end

  def require_module module_name
    module_full_path = File.join(APPFOLDER,'lib','modules',module_name)
    File.exist?(module_full_path) || begin
      ct('system.errors.unknown_module_required', {module_name: module_name})
    rescue Exception => e
      raise_by_mode(e, CLI.verbose? ? :tout_voir : Scrivener.mode)
      raise
    end
    Dir['%s/**/*.rb' % [module_full_path]].each do |m|
      # puts '--> require %s' % m
      require m
    end
  end

  # Require un texte qui se trouve dans le dossier './assets/textes/'. Ce
  # texte doit se trouver dans un module (p.e. 'module MonModule'), sous
  # forme de constante, pour être utilisé par :
  #   Scrivener.require_texte('mon_texte')
  #   puts MonModule::TEXTE
  #
  # Ces textes sont localisés, c'est-à-dire qu'on prend celui de la
  # langue et, à défaut, celui en anglais.
  #
  def require_texte(relpath)
    require required_texte_path(relpath)
  end

  # Retourne le path du texte en fonction de la langue
  def required_texte_path(relpath)
    pth = required_texte_path_in_lang(relpath, lang)
    pth || begin
      lang != :en || raise
      pth = required_texte_path_in_lang(relpath, :en)
    end
    pth || raise
  rescue
    fail(LoadError, 'Unfound text file "%s"…' % relpath)
  end
  def required_texte_path_in_lang(relpath, lg)
    pth = File.join(APPFOLDER,'assets','textes', lg.to_s, relpath)
    puts "--pth: #{pth.with_extension('rb')}"
    File.exist?(pth.with_extension('rb')) || return
    return pth
  end

end #/<< self
end #/Scrivener
