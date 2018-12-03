# encoding: UTF-8
class Float

  # Pour obtenir '1' quand c'est '1.0' et le nombre de
  # décimales voulues
  # Retourne un string
  def pretty_round nombre_decimales = 2
    n = self.round(nombre_decimales).to_s
    e, d = n.split('.')
    d.to_i == 0 ? e : n
  end

  # Retourne le floatant sous forme de pourcentage ou de pourmillage
  # Note : la méthode existe aussi pour les flottants (plus précise)
  # Rappel : pour obtenir le pourcentage, on fait <nombre>/<nombre total>
  def pourcentage pour_mille = false
    "#{(self * 100).pretty_round(1)} #{pour_mille ? '‰' : '%'}"
  end

end
