
class Scrivener
  class Project
    class BinderItem

      class << self
        def next_index
          @last_index ||= 0
          @last_index += 1
        end
      end#/ << self

      def treate_proximite tableau

        # On crée un enregistrement dans le tableau des données du binder-item
        # avec notamment son UUID et ses offsets de départ et de fin
        tableau[:binder_items].merge!(
          self.uuid => {
            index:        parent? ? nil : self.class.next_index,
            uuid:         self.uuid,
            title:        self.title,
            length:       (texte||'').length, # longueur du texte
            offset_start: tableau[:current_offset],
            offset_end:   nil,
            proximites:   nil, # ou liste des ID de proximités
            densite:      nil  # ou la densité sur mille
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
