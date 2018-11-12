=begin
  Module principal qui permet de traiter les proximités d'après le
  tableau des mots consignés.
=end
class Scrivener
  class Project


    # = main =
    #
    # Méthode principale, appelée après la relève des mots, pour calculer
    # les proximités des mots.
    #
    # +tableau+ Tableau de résultats ou se trouve déjà les mots, et peut-être
    # aussi les proximites
    def calcul_proximites(tableau)
      CLI.dbg("-> Scrivener::Project#calcul_proximites (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")

      # Pour mettre toutes les proximités. Donc elles se trouveront
      # à deux endroits, dans cette table et dans les données du mot (mais
      # seulement sous forme d'identifiant)
      tableau[:proximites]  = Hash.new
      last_proximite_id     = 0

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
            # On crée une instance proximité
            last_proximite_id += 1
            iproximite = Proximite.new(last_proximite_id, previous_imot, imot)
            # On associe les mots à leur proximité
            previous_imot.proximite_apres= iproximite
            imot.proximite_avant= iproximite
            # On met dans les listes
            tableau[:proximites].merge!(last_proximite_id => iproximite)
            data_mot[:proximites] << last_proximite_id
          end

        end
        # /fin de boucle sur chaque occurence du mot

      end
      # /boucle sur chaque mot différent

      # On mémorise les données des mots et on l'enregistre dans le
      # fichier `.proximites`
      self.tableau_proximites = tableau

      # On enregistre les résultats dans un fichier
      save_proximites

    end
  end #/Project
end #/Scrivener
