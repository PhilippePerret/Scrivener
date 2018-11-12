class Scrivener
  class Project

    # Méthode qui boucle sur tous les textes du projet, pour produire
    # un unique fichier.
    def assemble_textes_binder_items
      CLI.dbg("-> Scrivener::Project#assemble_textes_binder_items (#{Scrivener.relative_path(__FILE__,__LINE__).gris})")
      File.exists?(whole_text_path) && File.unlink(whole_text_path)
      File.open(whole_text_path,'w') do |f|
        binder_items.each do |bitem|
          bitem.add_in_file(f) # cf. ci-dessous
        end
      end
    end
    # /assemble_textes_binder_items

    def whole_text_path
      @whole_text_path ||= File.join(self.hidden_folder,'whole_texte.txt')
    end

    class BinderItem
      def add_in_file fdescriptor
        self.has_text? && fdescriptor.write(self.texte  + String::RC)
        self.parent? || return
        self.children.each { |child| child.add_in_file(fdescriptor) }
      end
    end
  end #/Project
end #/Scrivener
