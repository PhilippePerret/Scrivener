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
      raise(ERRORS[:unknown_module_required] % module_name)
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
  # texte doit se trouve dans un module (p.e. 'module MonModule'), sous
  # forme de constante, pour être utilisé par :
  #   Scrivener.require_texte('mon_texte')
  #   puts MonModule::TEXTE
  def require_texte(relpath)
    pth = File.join(APPFOLDER,'assets','textes',relpath)
    pth_c = pth.end_with?('.rb') ? pth : pth + '.rb'
    File.exist?(pth_c) || fail(LoadError, 'Le pth "%s" est introuvable' % pth)
    require pth
  end

end #/<< self
end #/Scrivener
