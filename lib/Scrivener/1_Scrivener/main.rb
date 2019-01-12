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

  # L'éditeur à utiliser pour éditer un texte. Soit c'est l'éditeur par
  # défaut, soit c'est l'éditeur précisé avec l'option --option="<éditeur>"
  def editor
    @editor ||= CLI.options[:open] === true ? ENV['SCRIV_EDITOR'] : CLI.options[:open]
  end

end #/<< self
end #/Scrivener
