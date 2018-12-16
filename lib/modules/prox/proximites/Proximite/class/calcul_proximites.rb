class Proximite
class << self

  # Pour mettre toutes les proximités.
  # Elles se trouveront à deux endroits dans la table :
  #   - dans cette table
  #   - dans la propriété :proximites du mot (mais seulement sous forme
  #     d'identifiant)
  # On boucle sur chaque mot différent du tableau
  #
  # Si project.watched_binder_item_uuid est défini, on ne doit vraiment checker
  # que les mots de ce binder-item.
  #
  def calcule_proximites_in tableau
    tableau[:mots].each do |mot_canonique, data_mot|
      data_mot[:proximites] = Array.new
      # puts "--- data_mot[:items] = #{data_mot[:items].inspect}"
      # Boucle sur chaque occurence du mot (instance {ProxMot})
      data_mot[:items].each_with_index do |imot, index_imot|
        index_imot > 0 || next
        if project.watched_binder_item_uuid && imot.binder_item_uuid != project.watched_binder_item_uuid
          # Il y a un binder-item surveillé et le mot courant n'appartient pas
          # à ce document. Donc on ne le considère pas.
          next
        end
        previous_imot = data_mot[:items][index_imot - 1]
        # Une occurence trop rapprochée trouvée
        imot.trop_proche_de?(previous_imot) && Proximite.create(tableau, previous_imot, imot)
      end
      # /fin de boucle sur chaque occurence du mot
    end
    # /boucle sur chaque mot différent
    return tableau
  end
  # /calcule_proximites_in

end #/ << self
end #/Proximite
