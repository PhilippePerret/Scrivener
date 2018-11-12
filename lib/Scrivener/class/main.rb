class Scrivener
  def self.require_module module_name
    Dir['%s/lib/modules/%s/**/*.rb' % [APPFOLDER, module_name]].each{|m|require m}
  end
end #/Scrivener
