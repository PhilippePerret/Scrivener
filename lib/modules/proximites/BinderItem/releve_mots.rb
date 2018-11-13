
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

#         texte = <<-EOT
# Un nouveau chapitre.
# Un autre !
#         EOT

        # pour les ponctuations finales, qui ne seraient pas traitées
        # sans ça.
        texte << ' EOT'

        # On commence par remplacer tous les caractères non alphanumérique par
        # des espaces (ponctuations, retour chariot), car sinon ils ne seraient
        # pas considérés par le scan.
        t = texte.gsub(/\r/,'').gsub(/[\n\.\!\?\;\… ]/, ' ')
        # NE SURTOUT PAS METTRE '_' qui sert pour les tags retirés

        cur_offset = tableau[:current_offset]
        bdi_offset = 0 # l'offset dans ce document (pour segment)
        cur_index  = tableau[:current_index_mot] # commence à -1

        # On peut scanner le texte
        t.scan(/\b(.+?)\b/).each do |found|

          seg = found[0]

          # Est-ce le dernier mot ?
          seg != 'EOT' || break

          # L'index courant
          # Noter qu'il sert aussi d'ID au mot
          cur_index += 1

          # Si le mot commence par une espace, c'est qu'il s'agit d'un
          # "inter-mot", qui peut être constitué de plusieurs espaces et
          # ponctuation, retour chariot et consorts.
          # La première chose à faire est de récupérer les signes originaux
          if seg[0] == ' '
            seg = mot = texte[bdi_offset...(bdi_offset + seg.length)]
            type_seg = :inter
          else
            mot = ProxMot.new(seg, cur_offset, cur_index, self.uuid)
            # On n'ajoute le mot au tableau que si c'est un vrai mot
            if mot.treatable?
              tableau = project.add_mot(mot)
            end
            type_seg = :mot
          end

          # Dans tous les cas, on ajoute le segment à la liste de tous
          # les mots du projet
          project.segments << {id: cur_index, seg: seg, type: type_seg}


          # Dans tous les cas on tient compte du décalage
          cur_offset += mot.length
          bdi_offset += mot.length
          # puts "--- current_offset après «#{mot.real}»:#{mot.length}:#{mot.offset}:('#{found[0]}'): #{tableau[:current_offset]}"
        end

        # Normalement, il faut ajouter 1 pour obtenir le vrai décalage dans
        # le fichier total, qui prend un retour de chariot en plus à la fin.
        cur_offset += 1

        tableau[:current_offset]    = cur_offset
        tableau[:current_index_mot] = cur_index

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
