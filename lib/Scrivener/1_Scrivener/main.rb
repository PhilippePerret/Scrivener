class Scrivener
class << self
  def require_module module_name
    module_full_path = File.join(APPFOLDER,'lib','modules',module_name)
    File.exist?(module_full_path) || raise(ERRORS[:unknown_module_required] % module_name)
    Dir['%s/**/*.rb' % [module_full_path]].each do |m|
      # puts '--> require %s' % m
      require m
    end
  end

  # Le mode actuel
  def mode
    if CLI.mode_test?
      :test
    elsif defined?(MODE_DEVELOPPEMENT) && MODE_DEVELOPPEMENT
      :development
    else
      :production
    end
  end
end #/<< self
end #/Scrivener
