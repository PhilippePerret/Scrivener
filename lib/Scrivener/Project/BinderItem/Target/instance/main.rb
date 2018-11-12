# encoding: UTF-8
class Scrivener
  class Project
    class BinderItem
      class Target

        attr_reader :binder_item
        def initialize binder_item
          @binder_item = binder_item
        end

        # {String} Objectif en nombre de pages
        def pages
          @pages ||= begin
            node? ? (mots.to_f / 250).pretty_round(1) : nil
          end
        end
        # Objectif en nombre de mots
        def mots
          @mots ||= begin
            node? ? (unite == 'Words' ? nombre : nombre / 7) : nil
          end
        end
        # Objectif en nombre de signes
        def signes
          @signes ||= begin
            node? ? (unite == 'Words' ? nombre * 7 : nombre) : nil
          end
        end

        def unite
          @unite ||= begin
            node? ? node.attributes['Type'] : nil
          end
        end
        def nombre
          @nombre ||= node? ? node.text.to_i : nil
        end

        def node?
          @has_node === nil && begin
            @has_node = !!(binder_item.node.elements['TextSettings'] && binder_item.node.elements['TextSettings/Target'])
          end
          @has_node
        end

        # Le noeud XML définissant la cible (target)
        def node
          @node ||= begin
            node? ? binder_item.node.elements['TextSettings/Target'] : nil
          end
        end

      end #/Target
    end #/BinderItem
  end #/Project
end #/Scrivener
