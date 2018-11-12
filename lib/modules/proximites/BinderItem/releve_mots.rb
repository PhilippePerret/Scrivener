
class Scrivener
  class Project
    class BinderItem

      def treate_proximite tableau

        # On crée un enregistrement dans le tableau des données du binder-item
        # avec notamment son UUID et ses offsets de départ et de fin
        tableau[:binder_items].merge!(
          self.uuid => {
            uuid:         self.uuid,
            title:        self.title,
            offset_start: tableau[:current_offset],
            offset_end:   nil
          }
        )
        has_text? && begin
          begin
            traite_texte(tableau)
          rescue Exception => e
            debug(e)
          end
        end
        tableau[:binder_items][uuid][:offset_end] = tableau[:current_offset]
        parent? && traite_children(tableau)
      end

      def traite_children tableau
        children.each { |child| child.treate_proximite(tableau)}
      end


      # Méthode qui traite le texte du binderitem
      def traite_texte tableau

        # On commence par remplacer tous les caractères non alphanumérique par
        # des espaces (ponctuations, retour chariot), car sinon ils ne seraient
        # pas considérés par le scan.
        t = texte.gsub(/\r/,'').gsub(/[\n\.\!\?\;\…]/, ' ')
        # NE SURTOUT PAS METTRE '_' qui sert pour les tags retirés

        # On peut scanner le texte
        t.scan(/\b(.+?)\b/) do |found|
        # texte.scan(/\b([a-zA-Z\.\n ]+?)\b/) do |found|
          # Note : ça capture les mots autant que les appostrophes ou les
          # ponctuation
          mot = ProxMot.new(found[0], tableau[:current_offset], self.uuid)

          # On n'ajoute le mot au tableau que si c'est un vrai mot
          if mot.treatable?
            tableau = project.add_mot(mot)
          end

          # Dans tous les cas on tient compte du décalage
          tableau[:current_offset] += mot.length
          # puts "--- current_offset après «#{mot.real}»:#{mot.length}:#{mot.offset}:('#{found[0]}'): #{tableau[:current_offset]}"
        end

        # Normalement, il faut ajouter 1 pour obtenir le vrai décalage dans
        # le fichier total, qui prend un retour de chariot en plus à la fin.
        tableau[:current_offset] += 1

      end
      # /traite_texte

    end #/BinderItem


    # ---------------------------------------------------------------------
    # Scrivener::Project

    # Ajoute le mot +imot+ au projet, en créant le record canonique au
    # besoin (s'il n'existe pas)
    # Attention : il ne suffit pas d'ajouter le mot, il faut aussi le placer
    # au bon endroit par rapport à son offset.
    def add_mot imot
      tb = self.tableau_proximites
      canon = imot.canonique
      tb[:mots].key?(canon) || begin
        tb[:mots].merge!(canon => {
          items:      Array.new,
          proximites: Array.new
        })
      end

      if tb[:mots][canon][:items].empty? || tb[:mots][canon][:items].last.offset < imot.offset
        # Si le nouveau mot est après le dernier, on l'ajoute
        # simplement au bout de la liste
        tb[:mots][canon][:items] << imot
      else
        # Il faut placer le mot au bon endroit
        index_insertion = -1
        tb[:mots][canon][:items].each_with_index do |mot, index_mot|
          if mot.offset > imot.offset
            index_insertion = index_mot
            break
          end
        end
        tb[:mots][canon][:items].insert(index_insertion, imot)
      end
      return tb
    end

  end #/Project
end #/Scrivener
