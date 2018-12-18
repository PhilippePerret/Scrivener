class Scrivener

  def self.require_module module_name
    Dir['%s/lib/modules/%s/**/*.rb' % [APPFOLDER, module_name]].each{|m|require m}
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
