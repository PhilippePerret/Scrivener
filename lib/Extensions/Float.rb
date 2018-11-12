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

end
