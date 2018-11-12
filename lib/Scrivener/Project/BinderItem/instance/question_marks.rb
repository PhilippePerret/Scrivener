# encoding: UTF-8
class Scrivener
  class Project
    class BinderItem


      # Retourne true si c'est un texte
      def text? ; type == 'Text' end

      # Retourne si le binder-item est de type Text et que son fichier texte
      # existe.
      def has_text?
        text? && File.exist?(rtf_text_path)
      end

      # Retourne true si l'élément a des enfants (rappel : un dossier ou un
      # texte peuvent avoir des enfants)
      def parent?
        @is_parent ||= node.elements['Children'] != nil
      end

      # Retourne TRUE si l'élément doit être compilé avec le manuscrit
      def compiled?
        @is_compiled ||= begin
          node.elements['MetaData'] &&
          node.elements['MetaData/IncludeInCompile'] &&
          node.elements['MetaData/IncludeInCompile'].text == 'Yes'
        end
      end

    end #/BinderItem
  end #/Project
end #/Scrivener
