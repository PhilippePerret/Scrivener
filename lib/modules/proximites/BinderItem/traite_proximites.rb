
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
        if has_text?
          begin
            releve_mots_in_texte(tableau)
          rescue Exception => e
            debug(e)
          end
        end
        tableau[:binder_items][uuid][:offset_end] = tableau[:current_offset]
        parent? && traite_children(tableau)
      end
      # /treate_proximite

      def traite_children tableau
        children.each { |child| child.treate_proximite(tableau)}
      end

    end #/BinderItem
  end #/Project
end #/Scrivener
