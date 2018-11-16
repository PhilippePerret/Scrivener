class Proximite
class << self

  def calcule_proximites_in tableau
    # Pour mettre toutes les proximités. Donc elles se trouveront
    # à deux endroits, dans cette table et dans les données du mot (mais
    # seulement sous forme d'identifiant)
    tableau[:proximites]  = Hash.new
    # On boucle sur chaque mot différent du tableau
    tableau[:mots].each do |mot_canonique, data_mot|
      data_mot[:proximites] = Array.new
      # puts "--- data_mot[:items] = #{data_mot[:items].inspect}"
      # Boucle sur chaque occurence du mot (instance {ProxMot})
      data_mot[:items].each_with_index do |imot, index_imot|
        index_imot > 0 || next
        previous_imot = data_mot[:items][index_imot - 1]
        # Une occurence trop rapprochée trouvée
        if imot.trop_proche_de?(previous_imot)
          iproximite = Proximite.create(tableau, previous_imot, imot)
        end

      end
      # /fin de boucle sur chaque occurence du mot
    end
    # /boucle sur chaque mot différent
    return tableau
  end
  # /calcule_proximites_in

end #/ << self
end #/Proximite
