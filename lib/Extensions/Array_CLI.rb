=begin
  Module étendant la classe Array pour les applications en ligne de commande

  Version: 1.0.0

  # Note version 1.0.0
    Création de l'extension, pour la méthode `face_a_face`
=end
class Array

  # Voir si on ne peut pas créer un template avant, plutôt, pour accélérer
  def face_to_face options = nil
    (options || @face_to_face_template.nil?) && define_face_to_face_template(options)
    face_to_face_template.call(self)
  end
  def define_face_to_face_template(options = nil)
    options = defaultize_face_to_face_options(options)
    self.face_to_face_template= Proc.new do |first, last|
      (' '*options[:margin]) + first.to_s.ljust(options[:width]) +
      options[:gutter] + last.to_s.ljust(options[:width]) + (' '*options[:margin]) + '|'
    end
  end
  def face_to_face_template= value
    @face_to_face_template = value
  end
  def face_to_face_template ; @face_to_face_template end
  def defaultize_face_to_face_options(options)
    options ||= Hash.new
    options.key?(:margin) || options.merge!(margin: 2)
    options.key?(:width)  || options.merge!(width: face_to_face_default_column_width)
    options.key?(:gutter) || options.merge!(gutter: '  ||  ')
    return options
  end
  def face_to_face_default_column_width
    @face_to_face_default_column_width ||= (String.screen_columns / 2) - (5 + 6)
  end

end #/Array
