# encoding: UTF-8
class Scrivener
  class Project
    class BinderItem
      class Target

        include XMLModule # => XML

        attr_reader :binder_item
        def initialize binder_item
          @binder_item = binder_item
        end

        # Raccourci
        def projet ; binder_item.projet end

        def define value, options = nil
          # <Target Type="Characters" Notify="No" ShowOverrun="Yes" ShowBuffer="Yes">1500</Target>
          attrs = Hash.new
          attrs.merge!('Notify'       => options[:notify] ? 'Yes' : 'No')
          attrs.merge!('ShowOverrun'  => options[:show_overrun] ? 'Yes' : 'No')
          attrs.merge!('ShowBuffer'   => options[:show_buffer] ? 'Yes' : 'No')
          attrs.merge!('Type'         => options[:type] ? options[:type] : 'Characters')
          node_tsetting = XML.get_or_add(binder_item.node, 'TextSettings')
          node_target   = XML.get_or_add(node_tsetting, 'Target')
          attrs.each do |prop, val|
            node_target.attributes[prop] = val
          end
          # node_target.attributes.merge!(attrs)
          node_target.text = value.to_s
          # Soit on sauve directement le fichier (si un seul changement)
          # soit on marque simplement que le fichier a été modifié
          if options[:save]
              projet.xfile.save
            else
              projet.xfile.set_modified
            end
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
            node? ? (unite == 'Words' ? nombre : nombre / 6) : nil
          end
        end
        # Objectif en nombre de signes
        def signes
          @signes ||= begin
            node? ? (unite == 'Words' ? nombre * 6 : nombre) : nil
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
