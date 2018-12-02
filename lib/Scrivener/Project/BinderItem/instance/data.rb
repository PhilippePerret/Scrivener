# encoding: UTF-8
require 'date'
class Scrivener
  class Project
    class BinderItem

      # Décalage obtenus à la volée du texte contenu par ce BinderItem
      # Il a été utilisé la première fois pour le calcul de proximité.
      attr_accessor :offset_start, :offset_end

      def type ; @type ||= attrs['Type'] end
      def uuid ; @uuid ||= attrs['UUID'] end
      def created_at ; @created_at ||= Date.parse(attrs['Created']) end
      def updated_at ; @updated_at ||= Date.parse(attrs['Modified']) end

      # Cf. le module texte.rb
      # # Le texte du fichier (au format txt simple)
      # # ------------------------------------------
      # # Il peut être pris de trois endroits différents :
      # #   - soit de la variable @texte déjà initialisée
      # #   - soit du fichier portant l'UUID dans .scriv/files/
      # #     (ce fichier correspond au fichier texte dans scrivener, mais
      # #     sans aucun balisage)
      # #   - soit du fichier dans Scrivener, qu'il faut traiter pour obtenir
      # #     le fichier ci-dessus
      # def texte
      #   @texte ||= begin
      #     if text? && File.exist?(rtf_text_path)
      #       # -stdout ci-dessous permet de retourner le texte transformé
      #       # Noter qu'on supprime toutes les balises qui se trouvent
      #       # éventuellement dans le fichier, comme des variables Scrivener
      #       # Le problème, c'est qu'on perdrait la correspondance au niveau des
      #       # offset des mots, donc on les remplaces par des 'SCRVTAGS'
      #       `textutil -format rtf -convert txt -stdout "#{rtf_text_path}"`.gsub(/<(.*?)>/) do |found|
      #         ' T' + '_'*(found.length - 2) + 'T '
      #       end
      #     end
      #   end
      # end

      # Les attributes du nœud
      def attrs ; @attrs ||= node.attributes end
      alias :attributes :attrs
        # Pour permettre d'atteindre les propriétés du nœud XML par le biais
        # de l'instance directement, en raccourci :
        #   binder_item.attributes => binder_item.node.attributes
        # Idem pour `elements` ci-dessous

      def elements
        @elements ||= node.elements
      end

      # Le titre du document
      # Mais ce titre peut ne pas être explicitement défini. Dans ce cas,
      # on prend le début du texte et si ce début du texte n'est pas défini,
      # on prend l'UUID
      def title
        @title ||= define_title
      end

      # On définit le titre, soit en prenant celui défini, soit en prenant
      # le début du texte, soit en prenant l'UUID du document.
      def define_title
        tit = nil
        if node.elements['Title']
          tit = node.elements['Title'].text.strip
        end
        tit ||= begin
          if texte.nil?
            self.uuid
          else
            # On fait un titre de moins de 30 lettres
            words = texte[0..50].split(' ')
            while words.join(' ').length > 30
              words.pop
            end
            words.join(' ')
          end
        end
      end

      def objectif
        @objectif ||= target.signes
      end

      # Instance de la cible de l'item
      def target
        @target ||= Target.new(self)
      end

      # Date de dernière modification du document content.rtf
      def current_mtime
        File.stat(rtf_text_path).mtime
      end

      def set_current_mtime
        self.last_mtime = current_mtime
      end

    end #/BinderItem
  end #/Project
end #/Scrivener
