class Scrivener
class << self

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
